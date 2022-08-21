//
//  TestsHelper.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 04/08/2022.
//

@testable import Reciplease

import Alamofire
import XCTest

class TestsHelper {
    static func initFavoriteRecipesWithIdsStoreMock(recipes: [Recipe]) async throws {
        try await initFavoriteRecipesWithIdsStoreMock(data: Set(recipes.map {$0.id}))
    }
    
    static func initFavoriteRecipesWithIdsStoreMock(data: Set<String> = Set()) async throws {
        let store = MockIdsStore()
        store.data = data
        try await FavoriteRecipes.shared.setIdsStore(store)
    }


    // Creating an RecipesAPIService with fake Session for testing without using network access
    static func buildRecipeAPIServiceMock() -> RecipesAPIService {
        let configuration = URLSessionConfiguration.af.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return RecipesAPIService(configuration: configuration)
    }
    
     // Reusable loader test functions

//    static func testSearchRecipesWithExpectedResultData(
//        _ loader: RecipesAPIService,
//        requestInputData: [String],
//        responseData: Data,
//        response: HTTPURLResponse,
//        expectedResultData: [Recipe]?
//    ) -> XCTestExpectation {
//        MockURLProtocol.requestHandler = { _ in
//            (response, responseData)
//        }
//
//        let expectation = XCTestExpectation(description: "response")
//        loader.searchRecipes(ingredients: requestInputData) { result in
//            XCTAssertEqual(result, expectedResultData)
//            expectation.fulfill()
//        }
//        return expectation
//    }

    static func testSearchRecipesWithExpectedResultData(
        _ loader: RecipesAPIService,
        requestInputData: [String],
        responseData: Data,
        response: HTTPURLResponse,
        expectedResultData: [Recipe]
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }

        let resultData = try! await loader.searchRecipes(ingredients: requestInputData)
        XCTAssertEqual(resultData, expectedResultData)
    }

    static func testSearchRecipesWithExpectedFailure(
        _ loader: RecipesAPIService,
        requestInputData: [String],
        responseData: Data,
        response: HTTPURLResponse
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }
        
        let mustThrownError = true
        do {
            _ = try await loader.searchRecipes(ingredients: requestInputData)
            XCTFail()
        } catch {
            XCTAssertTrue(mustThrownError)
        }
    }

    static func testSearchRecipesExpectedFailureWhenErrorIsThrownDuringLoading(
        _ loader: RecipesAPIService,
        requestInputData: [String],
        thrownError: Error
    ) async throws {
        MockURLProtocol.requestHandler = { _ in
            throw thrownError
        }

        let mustThrownError = true
        do {
            _ = try await loader.searchRecipes(ingredients: requestInputData)
            XCTFail()
        } catch {
            XCTAssertTrue(mustThrownError)
        }
    }

    static func testLoadRecipeWithExpectedResultData(
        _ loader: RecipesAPIService,
        requestInputData: String,
        responseData: Data,
        response: HTTPURLResponse,
        expectedResultData: Recipe
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }

        let resultData = try! await loader.loadRecipe(id: requestInputData)
        XCTAssertEqual(resultData, expectedResultData)
    }

    static func testLoadRecipeWithExpectedFailure(
        _ loader: RecipesAPIService,
        requestInputData: String,
        responseData: Data,
        response: HTTPURLResponse
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }
        
        let mustThrownError = true
        do {
            _ = try await loader.loadRecipe(id: requestInputData)
            XCTFail()
        } catch {
            XCTAssertTrue(mustThrownError)
        }
    }

    static func testLoadRecipeExpectedFailureWhenErrorIsThrownDuringLoading(
        _ loader: RecipesAPIService,
        requestInputData: String,
        thrownError: Error
    ) async throws {
        MockURLProtocol.requestHandler = { _ in
            throw thrownError
        }

        let mustThrownError = true
        do {
            _ = try await loader.loadRecipe(id: requestInputData)
            XCTFail()
        } catch {
            XCTAssertTrue(mustThrownError)
        }
    }
}
