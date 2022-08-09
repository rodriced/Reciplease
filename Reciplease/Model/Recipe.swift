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

    private(set) var ids = Set<String>()

    static var idsStore: IdsStoreProto!

    func load() async throws {
        let ids = try await Self.idsStore.load()
        self.ids = Set(ids)
    }

    func contains(_ recipe: Recipe) -> Bool {
        ids.contains(recipe.id)
    }

    func add(_ recipe: Recipe) async throws {
        try await Self.idsStore.add(recipe.id)
        ids.insert(recipe.id)
    }

    func remove(_ recipe: Recipe) async throws {
        try await Self.idsStore.remove(recipe.id)
        ids.remove(recipe.id)
    }
}
