//
//  Config.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 06/08/2022.
//

import Foundation

class Config {
    
    static func readPListFile(ressource: String) -> [String: String]? {
        let configUrl = Bundle.main.url(forResource: ressource, withExtension: "plist")!
        let data = try! Data(contentsOf: configUrl)
        return try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String: String]
    }
    
    static func getAlamofireConfig() -> [String: String]? {
        readPListFile(ressource: "Alamofire-Info")
    }
}
