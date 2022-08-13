//
//  SearchRecipesAPITestCase.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

@testable import Reciplease

import XCTest

class SearchRecipesAPITestCase: XCTestCase {
    // Data for tests
    static let requestInputDataOK = ["salad"]

    override func setUp() {
//        FavoriteRecipes.shared.idsStore = MockIdsStore()
        Task {
            try await FavoriteRecipesIds.shared.setIdsStore(MockIdsStore())
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

//    func testSearchRecipesFailureWhenMissingApiKey() {
//        let apiRequest = TranslationRequest(subscriptionKey: nil)
//        let loader = TestsHelper.buildTestLoader(apiRequest)
//
//        await TestsHelper.testSearchRecipesWithExpectedResultData(
//            loader,
//            requestInputData: Self.requestInputDataOK,
//            responseData: Self.fakeResponseData.dataOK,
//            response: Self.fakeResponseData.responseOK,
//            expectedResultData: nil
//        )
//    }

//    func testSearchRecipesFailureWhenInputParameterHasMissingValue() async {
//        let loader = TestsHelper.buildRecipeAPIServiceMock()
//
//        await TestsHelper.testSearchRecipesWithExpectedResultData(
//            loader,
//            requestInputData: Self.requestInputDataWithMissingValue,
//            responseData: Self.fakeResponseData.dataOK,
//            response: Self.fakeResponseData.responseOK,
//            expectedResultData: nil
//        )
//    }

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
