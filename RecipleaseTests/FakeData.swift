//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Rodolphe Desruelles on 29/06/2022.
//
@testable import Reciplease

import Foundation

class FakeDataError : Error {}

class FakeData {

    static func dataFromRessource(_ resource: String) -> Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: resource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    static let badJsondata = "bad json".data(using: .utf8)!
    
    static let httpResponseOK = httpResponse(statusCode: 200)
    static let httpResponseKO = httpResponse(statusCode: 500)

    static func httpResponse(statusCode: Int = 200, contentType: String = "application/json") -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: statusCode, httpVersion: nil, headerFields: ["Content-Type": contentType])!
    }

//    private let response = { HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: $0, httpVersion: nil, headerFields: [:])! }
//
//    lazy var responseOK = response(200)
//    lazy var responseKO = response(500)

    static let error = FakeDataError()

    static let decoder = JSONDecoder()

//    lazy var decodedDataOK =
//        (try! Self.decoder.decode(SearchRecipesResultData.self, from: dataOK)).recipes
    
    static let searchRecipesResultDataOK = FakeData.dataFromRessource("SearchRecipesResultDataOK")!
    static let searchRecipesResultOK = (try! decoder.decode(SearchRecipesResultData.self, from: searchRecipesResultDataOK)).recipes

    static let searchRecipesResultDataKOWithMissingField = FakeData.dataFromRessource("SearchRecipesResultDataKO")!

    static let loadRecipeResultDataOK = FakeData.dataFromRessource("LoadRecipeResultDataOK")!
    static let loadRecipeResultOK = (try! decoder.decode(LoadRecipeResultData.self, from: loadRecipeResultDataOK)).recipe

    static let loadRecipeResultDataKOWithMissingField = FakeData.dataFromRessource("LoadRecipeResultDataKO")!
}
