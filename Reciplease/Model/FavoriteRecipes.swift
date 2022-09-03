//
//  FavoriteRecipes.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Foundation

class FavoriteRecipes {
    static var shared = FavoriteRecipes()
    private init() {}

    private(set) var recipesCache = [String: Recipe?]()
    private(set) var idsStore: IdsStoreProto?

    func setIdsStore(_ idsStore: IdsStoreProto) async throws {
        self.idsStore = nil

        let ids = try await idsStore.load()
        updateCache(with: ids)

        self.idsStore = idsStore

        idsStore.addListener { ids in
//            print("favoriteRecipesChanged : \(String(describing: ids))")
//            guard let ids = ids else { return }

            if let ids = ids { self.updateCache(with: ids) }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
        }
    }

    func reset() {
        idsStore = nil
        recipesCache = [String: Recipe?]()
    }

    private func updateCache(with ids: [String]) {
        var newRecipesCache = [String: Recipe?]()
        for id in ids {
            newRecipesCache[id] = recipesCache[id, default: nil]
        }
        recipesCache = newRecipesCache
    }

    func contains(_ recipe: Recipe) -> Bool {
        recipesCache[recipe.id] != nil
    }

    func getAll(loader: RecipesAPIService = RecipesAPIService.shared) async throws -> [Recipe]? {
        guard let _ = idsStore else { return nil }

        return try await recipesCache.concurrentMap { id, recipe in
            if let recipe = recipe {
                // Cache hit
                return recipe
            }
            let recipe = try await loader.loadRecipe(id: id)
            self.recipesCache[id] = recipe
            return recipe
        }
    }

    func add(_ recipe: Recipe) async throws {
        guard let idsStore = idsStore else { return }

        try await idsStore.add(recipe.id)
        recipesCache[recipe.id] = recipe
    }

    func remove(_ recipe: Recipe) async throws {
        guard let idsStore = idsStore else { return }

        try await idsStore.remove(recipe.id)
        recipesCache[recipe.id] = nil
    }
}
