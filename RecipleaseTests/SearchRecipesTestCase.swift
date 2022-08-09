//
//  SearchRecipesTestCase.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

@testable import Reciplease

import XCTest

class SearchRecipesTestCase: XCTestCase {
    // Data for tests
    static let decoder = JSONDecoder()

    static let fakeResponseData = FakeResponseData(dataResourceOK: "SearchRecipesResultDataOK")

    static let responseDataWithMissingField = FakeResponseData.dataFromRessource("SearchRecipesResultDataKO")!
    static let requestResultDataOK =
        (try! decoder.decode(RecipesRequestData.self, from: fakeResponseData.dataOK))
            .hits.map { $0.recipe }

    static let requestInputDataOK = ["salad"]

//    static let requestInputDataOK = TranslationRequestInputData(
//        targetLanguage: "en",
//        sourceLanguage: "fr",
//        text: "Bonjour, comment allez-vous ?"
//    )
//
//    static let requestInputDataWithMissingValue = TranslationRequestInputData(
//        targetLanguage: "",
//        sourceLanguage: "fr",
//        text: "Bonjour, comment allez-vous ?"
//    )

    override func setUp() {
        FavoriteRecipes.idsStore = MockIdsStore()
    }
    
    // Loader tests

    func testSearchRecipesSuccess() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: Self.fakeResponseData.dataOK,
            response: Self.fakeResponseData.responseOK,
            expectedResultData: Self.requestResultDataOK
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

        await TestsHelper.testSearchRecipesWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: Self.responseDataWithMissingField,
            response: Self.fakeResponseData.responseOK,
            expectedResultData: nil
        )
    }

    func testSearchRecipesFailureWhenDataIsBadJson() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: Self.fakeResponseData.badJsondata,
            response: Self.fakeResponseData.responseOK,
            expectedResultData: nil
        )
    }

    func testSearchRecipesFailureWhenHTTPResponseStatusCodeIsNot200() async {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        await TestsHelper.testSearchRecipesWithExpectedResultData(
            loader,
            requestInputData: Self.requestInputDataOK,
            responseData: Self.fakeResponseData.dataOK,
            response: Self.fakeResponseData.responseKO,
            expectedResultData: nil
        )
    }

    func testSearchRecipesFailureWhenErrorIsThrownDuringLoading() async throws {
        let loader = TestsHelper.buildRecipeAPIServiceMock()

        try await TestsHelper.testSearchRecipesExpectedFailureWhenErrorIsThrownDuringLoading(
            loader,
            requestInputData: Self.requestInputDataOK,
            thrownError: FakeResponseData.error
        )
    }
}
