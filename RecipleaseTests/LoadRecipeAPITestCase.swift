//
//  LoadRecipeAPITestCase.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

@testable import Reciplease

import XCTest

class LoadRecipeAPITestCase: XCTestCase {
    // Data for tests
    static let requestInputDataOK = FakeData.loadRecipeResultOK.id

    override func setUp() {
//        FavoriteRecipes.shared.idsStore = MockIdsStore()
        Task {
            try await FavoriteRecipesIds.shared.setIdsStore(MockIdsStore())
        }
    }

    // Loader tests

    func testSearchRecipesSuccess() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testLoadRecipeWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.loadRecipeResultDataOK,
            response: FakeData.httpResponseOK,
            expectedResultData: FakeData.loadRecipeResultOK
        )
    }

//    func testSearchRecipesFailureWhenMissingApiKey() {
//        let apiRequest = TranslationRequest(subscriptionKey: nil)
//        let loader = TestsHelper.buildTestLoader(apiRequest)
//
//        await TestsHelper.testLoadRecipeWithExpectedResultData(
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
//        await TestsHelper.testLoadRecipeWithExpectedResultData(
//            loader,
//            requestInputData: Self.requestInputDataWithMissingValue,
//            responseData: Self.fakeResponseData.dataOK,
//            response: Self.fakeResponseData.responseOK,
//            expectedResultData: nil
//        )
//    }

    func testSearchRecipesFailureWhenResponseDataHasMissingField() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testLoadRecipeWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.loadRecipeResultDataKOWithMissingField,
            response: FakeData.httpResponseOK
        )
    }

    func testSearchRecipesFailureWhenDataIsBadJson() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testLoadRecipeWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.badJsondata,
            response: FakeData.httpResponseOK
        )
    }

    func testSearchRecipesFailureWhenHTTPResponseStatusCodeIsNot200() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testLoadRecipeWithExpectedFailure(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: FakeData.loadRecipeResultDataOK,
            response: FakeData.httpResponseKO
        )
    }

    func testSearchRecipesFailureWhenErrorIsThrownDuringLoading() async throws {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        try await TestsHelper.testLoadRecipeExpectedFailureWhenErrorIsThrownDuringLoading(
            loader,
            requestInputData: Self.requestInputDataOK,
            thrownError: FakeData.error
        )
    }
}