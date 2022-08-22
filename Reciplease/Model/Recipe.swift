//
//  Recipes.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Foundation

struct RecipientIngredient: Decodable {
    let food: String
}

struct Recipe: Equatable {
    enum CodingKeys: CodingKey, CaseIterable {
        case uri, label, image, url, yield, ingredientLines, ingredients, totalTime
    }

    let id: String
    let label: String
    let image: String
    let url: String
    let yield: Float
    let ingredientLines: [String]
    let foods: [String]
    let totalTime: Float

    var isFavorite: Bool {
        FavoriteRecipes.shared.contains(self)
    }

    func setFavorite(_ favorite: Bool) async throws {
        if favorite {
            try await FavoriteRecipes.shared.add(self)
        } else {
            try await FavoriteRecipes.shared.remove(self)
        }
    }

    func toggleFavorite() async throws {
        try await setFavorite(!isFavorite)
    }
}

extension Recipe: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let uri = try values.decode(String.self, forKey: .uri)
        id = URL(string: uri)!.fragment!

        label = try values.decode(String.self, forKey: .label)
        image = try values.decode(String.self, forKey: .image)
        url = try values.decode(String.self, forKey: .url)
        yield = try values.decode(Float.self, forKey: .yield)
        ingredientLines = try values.decode([String].self, forKey: .ingredientLines)
        totalTime = try values.decode(Float.self, forKey: .totalTime)

        let recipeIngredients = try values.decode([RecipientIngredient].self, forKey: .ingredients)
        foods = recipeIngredients.map { $0.food }
    }
}

class FavoriteRecipes {
    static var shared = FavoriteRecipes()
    private init() {}

    private(set) var recipesCache = [String: Recipe?]()
    private(set) var idsStore: IdsStoreProto!

    func setIdsStore(_ idsStore: IdsStoreProto) async throws {
        self.idsStore = idsStore
        try await syncCache()

        idsStore.addListener { ids in
            print("favoriteRecipesChanged : \(String(describing: ids))")
//            guard let ids = ids else { return }

            if let ids = ids { self.syncCache(with: ids) }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
        }
    }

    private func syncCache() async throws {
        let ids = try await idsStore.load()
        syncCache(with: ids)
    }

    private func syncCache(with ids: [String]) {
        var newRecipesCache = [String: Recipe?]()
        for id in ids {
            newRecipesCache[id] = recipesCache[id, default: nil]
        }
        recipesCache = newRecipesCache
    }

    func contains(_ recipe: Recipe) -> Bool {
        recipesCache[recipe.id] != nil
    }

    func getAll() async throws -> [Recipe]? {
        return try await recipesCache.concurrentMap { id, recipe in
            if let recipe = recipe {
                return recipe
            }
            let recipe = try await RecipesAPIService.shared.loadRecipe(id: id)
            self.recipesCache[id] = recipe
            return recipe
        }
    }

    func add(_ recipe: Recipe) async throws {
        try await idsStore.add(recipe.id)
        recipesCache[recipe.id] = recipe
    }

    func remove(_ recipe: Recipe) async throws {
        try await idsStore.remove(recipe.id)
        recipesCache[recipe.id] = nil
    }
}
