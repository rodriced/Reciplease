//
//  RecipeAPI.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

import Foundation
import Alamofire

class RecipesAPIRequestBase {
    let session: Session

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
}

class SearchRecipeAPIService {
    
}
