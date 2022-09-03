//
//  FakeData.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 03/08/2022.
//

@testable import Reciplease

import Foundation

class FakeDataError: Error {}

class FakeData {
    static func dataFromRessource(_ resource: String) -> Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: resource, withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    static let decoder = JSONDecoder()
    
    static let error = FakeDataError()

    // MARK: - Responses

    static let badJsondata = "bad json".data(using: .utf8)!
    
    static let httpResponseOK = httpResponse(statusCode: 200)
    static let httpResponseKO = httpResponse(statusCode: 500)

    static func httpResponse(statusCode: Int = 200, contentType: String = "application/json") -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: statusCode, httpVersion: nil, headerFields: ["Content-Type": contentType])!
    }

    // MARK: - SearchRecipes results

    static let searchRecipesResultDataOK = FakeData.dataFromRessource("SearchRecipesResultDataOK")!
    static let searchRecipesResultOK = (try! decoder.decode(SearchRecipesResultData.self, from: searchRecipesResultDataOK)).recipes

    static let searchRecipesResultDataKOWithMissingField = FakeData.dataFromRessource("SearchRecipesResultDataKO")!

    // MARK: - loadRecipes results

    static let loadRecipeResultDataOK = FakeData.dataFromRessource("LoadRecipeResultDataOK")!
    static let loadRecipeResultOK = (try! decoder.decode(LoadRecipeResultData.self, from: loadRecipeResultDataOK)).recipe

    static let loadRecipeResultDataKOWithMissingField = FakeData.dataFromRessource("LoadRecipeResultDataKO")!

    // MARK: - loadFavoriteRecipe results

    typealias RecipeResultDataDict = [String: (data: Data, recipe: Recipe)]

    static let loadFavoriteRecipeResultDataDictOK: RecipeResultDataDict = {
        let jsonObject = (try! JSONSerialization.jsonObject(with: searchRecipesResultDataOK)) as! [String: Any]
        let jsonHits = jsonObject["hits"] as! [Any]
        return jsonHits.reduce(into: RecipeResultDataDict()) { dict, recipeJsonObject in
            let recipeData = try! JSONSerialization.data(withJSONObject: recipeJsonObject)
            let recipe = (try! decoder.decode(LoadRecipeResultData.self, from: recipeData)).recipe
            dict[recipe.id] = (data: recipeData, recipe: recipe)
        }
    }()
}
