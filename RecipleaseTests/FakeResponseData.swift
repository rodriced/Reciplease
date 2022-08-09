//
//  FakeResponseData.swift
//  LeBaluchonTests
//
//  Created by Rodolphe Desruelles on 29/06/2022.
//
@testable import Reciplease

import Foundation

class FakeResponseDataError : Error {}

class FakeResponseData {

    static func dataFromRessource(_ resource: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: resource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    init(dataResourceOK: String) {
        dataOK = Self.dataFromRessource(dataResourceOK)!
        responseOK = Self.httpResponse(statusCode: 200)
        responseKO = Self.httpResponse(statusCode: 500)
    }

    var dataOK: Data
    let badJsondata = "bad json".data(using: .utf8)!
    
    let responseOK: HTTPURLResponse
    let responseKO: HTTPURLResponse

    static func httpResponse(statusCode: Int = 200, contentType: String = "application/json") -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: statusCode, httpVersion: nil, headerFields: ["Content-Type": contentType])!
    }

//    private let response = { HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: $0, httpVersion: nil, headerFields: [:])! }
//
//    lazy var responseOK = response(200)
//    lazy var responseKO = response(500)

    static let error = FakeResponseDataError()

    static let decoder = JSONDecoder()

    lazy var resultDataOK =
    (try! Self.decoder.decode(RecipesRequestData.self, from: dataOK))
            .hits.map { $0.recipe }

}
