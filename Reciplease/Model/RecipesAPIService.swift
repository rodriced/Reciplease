//
//  Recipes.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Alamofire
import Foundation

struct RecipeData: Decodable {
    let recipe: Recipe
}

struct RecipesRequestData: Decodable {
    let hits: [RecipeData]
}

class RecipesAPIService {
    let session: Session
    static let shared = RecipesAPIService()

    let baseUrl = "https://api.edamam.com/api/recipes/v2"

    let baseParameters: [String: Any]
    let headers: HTTPHeaders = [.accept("application/json"),
                                .defaultUserAgent,
                                .acceptEncoding("gzip")]

    init?(configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        session = Session(configuration: configuration)
        let config = Config.getAlamofireConfig() ?? [:]

        baseParameters = [
            "type": "public",
            "field": Recipe.CodingKeys.allCases.map { "\($0)" },
            "app_id": config["EDAMAM_APPLICATION_ID"] ?? "",
            "app_key": config["EDAMAM_APPLICATION_KEY"] ?? ""
        ]
    }

    func searchRecipes(ingredients: [String], completionHandler: @escaping ([Recipe]?) -> Void) {
        var parameters = baseParameters
        parameters["q"] = ingredients.joined(separator: ",")

        session.request(baseUrl, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: RecipesRequestData.self) { response in
                switch response.result {
                case .success(let recipesRequestData):
//                    debugPrint(recipesRequestData)
                    completionHandler(recipesRequestData.hits.map { $0.recipe })
                case .failure(let afError):
                    debugPrint(afError)
                    completionHandler(nil)
                }
            }
    }

    func searchRecipesTask(ingredients: [String]) async -> [Recipe]? {
        return await withCheckedContinuation() { continuation in
            var parameters = baseParameters
            parameters["q"] = ingredients.joined(separator: ",")

            session.request(baseUrl, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: RecipesRequestData.self) { response in
                    switch response.result {
                    case .success(let recipesRequestData):
//                    debugPrint(recipesRequestData)
                        return continuation.resume(returning: recipesRequestData.hits.map { $0.recipe })
                    case .failure(let afError):
                        debugPrint(afError)
                        return continuation.resume(returning: nil)
                    }
                }
        }
    }

    func loadRecipe(id: String) async throws -> Recipe {
        return try await withCheckedThrowingContinuation() { continuation in
            let url = "\(baseUrl)/\(id)"

            session.request(url, parameters: baseParameters, headers: headers)
                .validate()
                .responseDecodable(of: RecipeData.self) {
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

    func loadRecipes(ids: [String]) async -> [Recipe]? {
        do {
            return try await ids.concurrentMap { id in
                try await self.loadRecipe(id: id)
            }
        } catch {
            return nil
        }
    }

    func loadFavoriteRecipes() async -> [Recipe]? {
        return await loadRecipes(ids: Array(FavoriteRecipes.shared.ids))
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    func concurrentMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) async throws -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }

        return try await tasks.asyncMap { task in
            try await task.value
        }
    }
}
