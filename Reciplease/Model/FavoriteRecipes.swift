//
//  FavoriteRecipes.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Foundation

#if false

class FavoriteRecipes {
    static var shared = FavoriteRecipes()
    private init() {}

    private var recipesCache: [String: Recipe?]?
    private var idsStore: IdsStoreProto!

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
//        guard let recipesCache = recipesCache else { return }

        var newRecipesCache = [String: Recipe?]()
        if let recipesCache = recipesCache {
            for id in ids {
                newRecipesCache[id] = recipesCache[id, default: nil]
            }
        }
        recipesCache = newRecipesCache
    }

    func contains(_ recipe: Recipe) -> Bool {
        guard let recipesCache = recipesCache else { return false }

        return recipesCache[recipe.id] != nil
    }

    func getAll() async throws -> [Recipe]? {
        guard var recipesCache = recipesCache else { return nil }

        return try await recipesCache.concurrentMap { id, recipe in
            if let recipe = recipe {
                return recipe
            }
            let recipe = try await RecipesAPIService.shared.loadRecipe(id: id)
            recipesCache[id] = recipe
            return recipe
        }
    }

    func add(_ recipe: Recipe) async throws {
        guard var recipesCache = recipesCache else { return }

        try await idsStore.add(recipe.id)
        recipesCache[recipe.id] = recipe
    }

    func remove(_ recipe: Recipe) async throws {
        guard var recipesCache = recipesCache else { return }

        try await idsStore.remove(recipe.id)
        recipesCache[recipe.id] = nil
    }
}

#else

class FavoriteRecipes {
    static var shared = FavoriteRecipes()
    private init() {}

    private(set) var recipesCache = [String: Recipe?]()
    private(set) var idsStore: IdsStoreProto?

    var isReady: Bool { idsStore != nil }

    func setIdsStore(_ idsStore: IdsStoreProto) async throws {
        self.idsStore = nil
        
        let ids = try await idsStore.load()
        updateCache(with: ids)

        self.idsStore = idsStore

        idsStore.addListener { ids in
            print("favoriteRecipesChanged : \(String(describing: ids))")
//            guard let ids = ids else { return }

            if let ids = ids { self.updateCache(with: ids) }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
        }
    }
    
//    private func syncCache() async throws {
//        let ids = try await idsStore.load()
//        updateCache(with: ids)
//    }

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

    func getAll() async throws -> [Recipe]? {
        guard isReady else { return nil }

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

//class FavoriteRecipes {
//    static var shared = FavoriteRecipes()
//    private init() {}
//
//    private(set) var recipesCache = [String: Recipe?]()
//    private(set) var idsStore: IdsStoreProto!
//
//    func setIdsStore(_ idsStore: IdsStoreProto) async throws {
//        self.idsStore = idsStore
//        try await syncCache()
//
//        idsStore.addListener { ids in
//            print("favoriteRecipesChanged : \(String(describing: ids))")
////            guard let ids = ids else { return }
//
//            if let ids = ids { self.updateCache(with: ids) }
//
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favoriteRecipesChanged"), object: nil)
//        }
//    }
//
//    private func syncCache() async throws {
//        let ids = try await idsStore.load()
//        updateCache(with: ids)
//    }
//
//    private func updateCache(with ids: [String]) {
//        var newRecipesCache = [String: Recipe?]()
//        for id in ids {
//            newRecipesCache[id] = recipesCache[id, default: nil]
//        }
//        recipesCache = newRecipesCache
//    }
//
//    func contains(_ recipe: Recipe) -> Bool {
//        recipesCache[recipe.id] != nil
//    }
//
//    func getAll() async throws -> [Recipe]? {
//        return try await recipesCache.concurrentMap { id, recipe in
//            if let recipe = recipe {
//                return recipe
//            }
//            let recipe = try await RecipesAPIService.shared.loadRecipe(id: id)
//            self.recipesCache[id] = recipe
//            return recipe
//        }
//    }
//
//    func add(_ recipe: Recipe) async throws {
//        try await idsStore.add(recipe.id)
//        recipesCache[recipe.id] = recipe
//    }
//
//    func remove(_ recipe: Recipe) async throws {
//        try await idsStore.remove(recipe.id)
//        recipesCache[recipe.id] = nil
//    }
//}

#endif
