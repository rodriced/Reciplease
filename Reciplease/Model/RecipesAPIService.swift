//
//  Recipes.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Alamofire
import Foundation

struct LoadRecipeResultData: Decodable {
    let recipe: Recipe
}

struct SearchRecipesResultData {
    enum RootKeys: String, CodingKey {
        case hits
        case links = "_links"
    }

    struct HitData: Decodable {
        let recipe: Recipe
    }

    enum LinksKeys: CodingKey {
        case next
    }

    enum NextKeys: CodingKey {
        case href
    }

    let recipes: [Recipe]
    let nextPageHref: String
}

extension SearchRecipesResultData: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootKeys.self)
        let hits = try values.decode([HitData].self, forKey: .hits)
        recipes = hits.map { $0.recipe }

        let links = try values.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)
        let next = try links.nestedContainer(keyedBy: NextKeys.self, forKey: .next)
        nextPageHref = try next.decode(String.self, forKey: .href)
    }
}

class RecipesAPIService {
    let session: Session
    static let shared = RecipesAPIService()

    let baseUrl = "https://api.edamam.com/api/recipes/v2"

    let baseParameters: [String: Any]
    let headers: HTTPHeaders = [.accept("application/json"),
                                .defaultUserAgent,
                                .acceptEncoding("gzip")]

    init(configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        session = Session(configuration: configuration)
        let config = Config.getAlamofireConfig() ?? [:]

        baseParameters = [
            "type": "public",
            "field": Recipe.CodingKeys.allCases.map { "\($0)" },
            "app_id": config["EDAMAM_APPLICATION_ID"] ?? "",
            "app_key": config["EDAMAM_APPLICATION_KEY"] ?? ""
        ]
    }

    func searchRecipes(ingredients: [String]) async throws -> [Recipe]? {
        return try await withCheckedThrowingContinuation() { continuation in
            var parameters = baseParameters
            parameters["q"] = ingredients.joined(separator: ",")

            session
                .request(baseUrl,
                            parameters: parameters,
                            headers: headers,
                            requestModifier: { $0.timeoutInterval = 5 })
                .validate()
                .responseDecodable(of: SearchRecipesResultData.self) { response in
                    switch response.result {
                    case .success(let recipesRequestData):
//                    debugPrint(recipesRequestData)
                        return continuation.resume(returning: recipesRequestData.recipes)
                    case .failure(let afError):
                        debugPrint(afError)
                        return continuation.resume(throwing: afError)
                    }
                }
        }
    }

    func loadRecipe(id: String) async throws -> Recipe {
        return try await withCheckedThrowingContinuation() { continuation in
            let url = "\(baseUrl)/\(id)"

            session.request(url, parameters: baseParameters, headers: headers)
                .validate()
                .responseDecodable(of: LoadRecipeResultData.self) {
                    response in

                    switch response.result {
                    case .success(let recipesData):
                        //                    debugPrint(recipesRequestData)
                        return continuation.resume(returning: recipesData.recipe)
                    case .failure(let afError):
                        debugPrint(afError)
                        continuation.resume(throwing: afError)
                    }
                }
        }
    }

//    func loadFavoriteRecipes() async throws -> [Recipe]? {
//        return try await FavoriteRecipesIds.shared.ids.concurrentMap { id in
//            try await self.loadRecipe(id: id)
//        }
//    }
}
