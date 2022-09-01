//
//  RecipleaseTests.swift
//  RecipeTests
//
//  Created by Rodolphe Desruelles on 07/08/2022.
//

@testable import Reciplease
import XCTest

class RecipeTests: XCTestCase {
    func testLoadFavoritesSuccess() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock(recipes: FakeData.searchRecipesResultOK)
        XCTAssertTrue(FavoriteRecipes.shared.contains(FakeData.searchRecipesResultOK[1]))
    }

    func testToggleFavoriteSuccess() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock()
        let recipe = FakeData.searchRecipesResultOK[0]

        try await recipe.toggleFavorite()
        XCTAssertTrue(FavoriteRecipes.shared.contains(recipe))

        try await recipe.toggleFavorite()
        XCTAssertFalse(FavoriteRecipes.shared.contains(recipe))
    }

    func testToggleFavoriteWithStoreThrowningError() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock()
        let recipe = FakeData.searchRecipesResultOK[0]

        (FavoriteRecipes.shared.idsStore as! MockIdsStore).errorThrown = true
        let favoriteSetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteSetResult)

        (FavoriteRecipes.shared.idsStore as! MockIdsStore).errorThrown = false
        try await recipe.toggleFavorite()

        (FavoriteRecipes.shared.idsStore as! MockIdsStore).errorThrown = true
        let favoriteUnsetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteUnsetResult)
    }
}
