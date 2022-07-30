//
//  Recipes.swift
//  Reciplease
//
//  Created by Rod on 25/07/2022.
//

import Alamofire
import Foundation

struct Recipe {
    static var favoritesIds = Set<String>()

    enum CodingKeys: CodingKey, CaseIterable {
        case uri, label, image, url, yield, ingredientLines, totalTime
    }

    let id: String
    let label: String
    let image: String
    let url: String
    let yield: Float
    let ingredientLines: [String]
    let totalTime: Float

    var isFavorite: Bool {
        Recipe.favoritesIds.contains(id)
    }

    func setFavorite(_ favorite: Bool) {
        if favorite {
            Self.favoritesIds.insert(id)
        } else {
            Self.favoritesIds.remove(id)
        }
    }

    func toggleFavorite() {
        setFavorite(!isFavorite)
    }

//    static let sample = Recipe(
//        uri: "",
//        label: "Greek chickpea salad with melting feta",
//        image: "https://edamam-product-images.s3.amazonaws.com/web-img/135/135a1f21ae76833258a2852c2e16fe7c.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEHwaCXVzLWVhc3QtMSJIMEYCIQDLAD9J10RjXWmDaI7T5Iu%2F%2F201f0wnYZxAhRnEEJgRegIhAPPtxOstUN74MJ9%2Bsv4CSxvaN%2BeMfxWM5vLT412o8VPDKtsECMX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQABoMMTg3MDE3MTUwOTg2IgxNVFFMoDuV8zWGHgkqrwRikmy93DFJEgQGkVZmbt1WSj9gpU%2B7dWtvkR8uMwa%2BxyuU6f%2FKz%2BkQJ%2FvJgeNIuwiVW7TUKUjwhUJrdR9cS5MANTtCwqchyCyCQOu2CUH4a4BXNGD3%2Fa%2B2RYLKbIgxQQhr1aIGqW7dJUQsJcPEumBoteOiOSnbIXCePLlm7WcaP2FlqaInkWeltB%2BZDygXguPpxsyTDrw486HrKtCGgvdzkBo7KRj4phAqHo3H%2FIae1jExQRJFjykOSEuaAOeg8b25C7mgN%2B3a323OwEfZK0%2BOeEEM2hpA6%2Bg9Y8sjEK1R0PzolhUpzqHlq8rP7PrYzsy66fU1eraovBthyR2UUJBs1t8fmK368cBE%2BiaQIf%2FOdnnGY9Q44huhB%2BUeXooQmCJHdS1aCb1W3RuRFaJMrGEIBk83xVyKyLPW9DE6teXb%2B2oKuV7ncw7FN%2B6o08FW9BjahlVXZg%2BaD%2FYkQnBrc%2F7UuO2C%2FwsNw4BjAXH6cfyPxvvetTlTHJokFeXqXiXc6YCe%2F387IBQ%2Fek2iJS7o6KGwvNjXV2l5qnWEVjK2ZVYt3wflnmgXNgp9Fw9eAZzjWRJlDMIJHCf5J3OLhVDh1to8%2Btv2sy1KUK158uEKV65hKePnZmW34CEh%2Fx76lO5EXL7K1yVWksv9%2BsvaSz3Ru53yo6vgAqL1ukzkJ%2BSmnn92vBPT%2FGei7x8rC7HYYbDz534zj0s05Stf9l%2BZr0htMnZG5TAK6L%2BACSv2kRBHkjM0MLWKgZcGOqgBlQwmLXm0CplkmLGVZjKOvcBiIc%2BlWdQqc4ntGWzGEzR%2F8ABPbeJg0gfkw3VYLYQBG095QwogRzwqqMdNr7AlDQFwOfyn2263JQbwFlqxD0loRHLueRj2%2FhoQqkUlOYfyHSgjAp7kMvIunxrKQ4ZfrhvxwoEG1PlYVMpng2aHMOVvXcYQKSCrrCyDStKHAv4%2FLL%2BKEfMxhPaIlOHCPmgimJwL0mUsgN0J&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220726T204351Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFHMIJXZFX%2F20220726%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=f10a2e520405f24e83a927125e7488fa87d380f11ce22384c46310db4c27bc94",
//        url: "https://www.bbcgoodfood.com/recipes/greek-chickpea-salad-melting-feta",
//        yield: 2.0,
//        ingredientLines: [
//            "1 tsp red wine vinegar",
//            "2 tsp rapeseed oil",
//            "good pinch of dried oregano or 1 tsp fresh, chopped",
//            "175g canned chickpeas , drained",
//            "1 small red onion , finely chopped",
//            "10cm/4in piece of cucumber , cut into chunks",
//            "6 pitted Kalamata olives , halved and rinsed to remove excess salt",
//            "3 tomatoes , cut into wedges",
//            "small handful mint leaves",
//            "2 tsp plain flour",
//            "½ tsp ground cumin",
//            "100g reduced-fat feta (sometimes called salad cheese), cubed",
//            "1-2 tsp rapeseed oil"
//        ],
//        totalTime: 15.0
//    )
}

extension Recipe: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let uri = try values.decode(String.self, forKey: .uri)
        id = URL(string: uri)!.fragment!
        label = try values.decode(String.self, forKey: .label)
        image = try values.decode(String.self, forKey: .image)
        url = try values.decode(String.self, forKey: .url)
        yield = try values.decode(Float.self, forKey: .yield)
        ingredientLines = try values.decode([String].self, forKey: .ingredientLines)
        totalTime = try values.decode(Float.self, forKey: .totalTime)
    }
}

struct RecipeData: Decodable {
    let recipe: Recipe
}

struct RecipesRequestData: Decodable {
//    enum CodingKeys: CodingKey {
//        case hits
//    }
    let hits: [RecipeData]
}

// struct RecipesRequestParameters: Encodable {
//    ////    static var config: NSDictionary? {
//    static var config: [String: String]? {
//        let configUrl = Bundle.main.url(forResource: "Alamofire-Info", withExtension: "plist")!
//        let data = try! Data(contentsOf: configUrl)
//        return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]
//    }
//
//    var q: String?
//    let type = "public"
//    let app_id: String?
//    let app_key: String?
//    let field = Recipe.CodingKeys.allCases.map { "\($0)" }
//
//    init() {
//        app_id = Self.config?["EDAMAM_APPLICATION_ID"]
//        app_key = Self.config?["EDAMAM_APPLICATION_KEY"]
//    }
// }

class RecipesAPIService {
    let baseUrl = "https://api.edamam.com/api/recipes/v2"

    let config: [String: String]
    let baseParameters: [String: Any]
    let headers: HTTPHeaders = [.accept("application/json"),
                                .defaultUserAgent,
                                .acceptEncoding("gzip")]

    static func getConfig() -> [String: String]? {
        let configUrl = Bundle.main.url(forResource: "Alamofire-Info", withExtension: "plist")!
        let data = try! Data(contentsOf: configUrl)
        return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]
    }

    static let shared = RecipesAPIService()

    private init?() {
        guard let config = Self.getConfig() else {
            return nil
        }
        self.config = config

        baseParameters = [
            "type": "public",
            "ield": Recipe.CodingKeys.allCases.map { "\($0)" },
            "app_id": config["EDAMAM_APPLICATION_ID"]!,
            "app_key": config["EDAMAM_APPLICATION_KEY"]!
        ]
    }

    func searchRecipes(ingredients: [String], completionHandler: @escaping ([Recipe]?) -> Void) {
        var parameters = baseParameters
        parameters["q"] = ingredients.joined(separator: ",")

        AF
            .request(baseUrl,
                     parameters: parameters,
                     headers: headers)
//            .cURLDescription { description in
//                print(description)
//            }
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

    func loadRecipe(id: String) async throws -> Recipe {
        return try await withCheckedThrowingContinuation() { continuation in
            let url = "\(baseUrl)/\(id)"

            AF
                .request(url,
                         parameters: baseParameters,
                         headers: headers)
//            .cURLDescription { description in
//                print(description)
//            }
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
        return await loadRecipes(ids: Array(Recipe.favoritesIds))
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
