//
//  FavoriteRecipesTests.swift
//  RecipeTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

@testable import Reciplease
import XCTest

class FavoriteRecipesTests: XCTestCase {
    override func setUp() {
        FavoriteRecipes.shared.reset()
    }
    
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
    
    func testFavoriteRecipesWithUndefinedIdsStore() async throws {
        let recipe = FakeData.searchRecipesResultOK[0]

        try await FavoriteRecipes.shared.remove(recipe)

        try await FavoriteRecipes.shared.add(recipe)
        XCTAssertFalse(FavoriteRecipes.shared.contains(recipe))

        let getAllResult = try await FavoriteRecipes.shared.getAll()
        XCTAssertNil(getAllResult)
    }

    func testConcurrentGetAllFavoriteRecipesSuccess() async throws {
        // Init API Servie Mock
        
        let recipeAPIServiceMock = TestsHelper.buildRecipeAPIServiceMock()
        
        MockURLProtocol.requestHandler = { request in
            let id = request.url!.path.split(separator: "/").last!
            let response = FakeData.httpResponseOK
            let responseData = FakeData.loadFavoriteRecipeResultDataDictOK[String(id)]!.data
            return (response, responseData)
        }

        // Init favorite recipes Store Mock
        
        try await FavoriteRecipes.shared.setIdsStore(MockIdsStore())

        // Random choosing recipes to be favorite recipes
        let favoriteRecipesDict = FakeData.loadFavoriteRecipeResultDataDictOK.filter { _ in
            (1 ... 10).randomElement()! < 5
        }
        try await TestsHelper.initFavoriteRecipesWithIdsStoreMock(recipes: favoriteRecipesDict.map { $1.recipe })
        
        // Testing
        
        let loadedFavoriteRecipes = (try await FavoriteRecipes.shared.getAll(loader: recipeAPIServiceMock))!

        XCTAssertNotNil(loadedFavoriteRecipes)

        let originalFavoritesRecipes = favoriteRecipesDict.values.map { $0.recipe }

        // We nees to sort before testing because concurrent loading doesn't guarantee the final order, and original dictionnary is not ordered
        let recpipeComparator: (Recipe, Recipe) -> Bool = {$0.id > $1.id}
        let sortedOriginalFavoriteRecipes: [Recipe] = originalFavoritesRecipes.sorted(by: recpipeComparator)
        
        XCTAssertEqual(loadedFavoriteRecipes.sorted(by: recpipeComparator), sortedOriginalFavoriteRecipes)
        
        let favoriteRecipesFromCache = (try await FavoriteRecipes.shared.getAll(loader: recipeAPIServiceMock))!
        
        XCTAssertEqual(favoriteRecipesFromCache.sorted(by: recpipeComparator), sortedOriginalFavoriteRecipes)
    }
}
