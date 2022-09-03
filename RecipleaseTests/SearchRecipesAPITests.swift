//
//  SearchRecipesAPITests.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

@testable import Reciplease

import XCTest

class SearchRecipesAPITests: XCTestCase {
    // Data for tests
    static let requestInputDataOK = ["salad"]

    override func setUp() {
        Task {
            try await FavoriteRecipes.shared.setIdsStore(MockIdsStore())
        }
    }

    // Loader tests

    func testSearchRecipesSuccess() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.searchRecipesResultDataOK,
            response: FakeData.httpResponseOK,
            expectedResultData: FakeData.searchRecipesResultOK
        )
    }

    func testSearchRecipesFailureWhenResponseDataHasMissingField() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.searchRecipesResultDataKOWithMissingField,
            response: FakeData.httpResponseOK
        )
    }

    func testSearchRecipesFailureWhenDataIsBadJson() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.badJsondata,
            response: FakeData.httpResponseOK
        )
    }

    func testSearchRecipesFailureWhenHTTPResponseStatusCodeIsNot200() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.searchRecipesResultDataOK,
            response: FakeData.httpResponseKO
        )
    }

    func testSearchRecipesFailureWhenErrorIsThrownDuringLoading() async throws {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        try await TestsHelper.testSearchRecipesExpectedFailureWhenErrorIsThrownDuringLoading(
            loader,
            requestInputData: Self.requestInputDataOK,
            thrownError: FakeData.error
        )
    }
}
