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
    // Creating an RecipesAPIService with fake Session for testing without using network access
    static func buildRecipeAPIServiceMock() -> RecipesAPIService {
        let configuration = URLSessionConfiguration.af.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return RecipesAPIService(configuration: configuration)!
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
        expectedResultData: [Recipe]?
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }

        let resultData = await loader.searchRecipesTask(ingredients: requestInputData)
        XCTAssertEqual(resultData, expectedResultData)
    }

    static func testloadRecipeWithExpectedResultData(
        _ loader: RecipesAPIService,
        requestInputData: [String],
        responseData: Data,
        response: HTTPURLResponse,
        expectedResultData: [Recipe]?
    ) async {
        MockURLProtocol.requestHandler = { _ in
            (response, responseData)
        }

        let resultData = await loader.loadRecipes(ids: requestInputData)
        XCTAssertEqual(resultData, expectedResultData)
    }

    static func testSearchRecipesExpectedFailureWhenErrorIsThrownDuringLoading(
        _ loader: RecipesAPIService,
        requestInputData: [String],
        thrownError: Error
    ) async throws {
        MockURLProtocol.requestHandler = { _ in
            throw thrownError
        }

        let result = await loader.searchRecipesTask(ingredients: requestInputData)
        XCTAssertNil(result)
    }
}
