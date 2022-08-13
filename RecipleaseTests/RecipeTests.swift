//
//  RecipleaseTests.swift
//  RecipeTests
//
//  Created by Rodolphe Desruelles on 07/08/2022.
//

import XCTest
@testable import Reciplease

class RecipeTests: XCTestCase {
    func testLoadFavoritesSuccess() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock(recipes: FakeData.searchRecipesResultOK)
        XCTAssertTrue(FavoriteRecipesIds.shared.contains(FakeData.searchRecipesResultOK[1]))
    }

    func testToggleFavoriteSuccess() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock()
        let recipe = FakeData.searchRecipesResultOK[0]
        
        try await recipe.toggleFavorite()
        XCTAssertTrue(FavoriteRecipesIds.shared.contains(recipe))
        
        try await recipe.toggleFavorite()
        XCTAssertFalse(FavoriteRecipesIds.shared.contains(recipe))
    }

    func testToggleFavoriteWithStoreThrowningError() async throws {
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock()
        let recipe = FakeData.searchRecipesResultOK[0]
        
        (FavoriteRecipesIds.shared.idsStore as! MockIdsStore).errorThrown = true
        let favoriteSetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteSetResult)
        
        (FavoriteRecipesIds.shared.idsStore as! MockIdsStore).errorThrown = false
        try await recipe.toggleFavorite()

        (FavoriteRecipesIds.shared.idsStore as! MockIdsStore).errorThrown = true
        let favoriteUnsetResult: ()? = try? await recipe.toggleFavorite()
        XCTAssertNil(favoriteUnsetResult)

    }

}
