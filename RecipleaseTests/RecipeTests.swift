//
//  RecipleaseTests.swift
//  RecipeTests
//
//  Created by Rodolphe Desruelles on 07/08/2022.
//

import XCTest
@testable import Reciplease

class RecipeTests: XCTestCase {
    static let fakeData = FakeResponseData(dataResourceOK: "SearchRecipesResultDataOK")

    override func setUp() {
        FavoriteRecipes.idsStore = MockIdsStore()
    }

    func testLoadFavoritesSuccess() async throws {
        let recipes = Self.fakeData.resultDataOK
        (FavoriteRecipes.idsStore as! MockIdsStore).store = Set(recipes.map {$0.id})

        try await FavoriteRecipes.shared.load()
        
        XCTAssertTrue(FavoriteRecipes.shared.contains(recipes[1]))
    }

    func testToggleFavoriteSuccess() async throws {
        let recipe = Self.fakeData.resultDataOK[0]
        
        try await recipe.toggleFavorite()
        XCTAssertTrue(FavoriteRecipes.shared.contains(recipe))
        
        try await recipe.toggleFavorite()
        XCTAssertFalse(FavoriteRecipes.shared.contains(recipe))
    }

    func testToggleFavoriteWithStoreThrowningError() async throws {
        let recipe = Self.fakeData.resultDataOK[0]
        
        (FavoriteRecipes.idsStore as! MockIdsStore).errorThrown = true
        let favoriteSetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteSetResult)
        
        (FavoriteRecipes.idsStore as! MockIdsStore).errorThrown = false
        try await recipe.toggleFavorite()

        (FavoriteRecipes.idsStore as! MockIdsStore).errorThrown = true
        let favoriteUnsetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteUnsetResult)

    }

}
