//
//  Search.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 25/07/2022.
//

import Foundation

//struct Ingredient {
//    let name: String
//}

class Search {
    private(set) var ingredients: [String] = []
    
    var isEmpty: Bool { ingredients.isEmpty}
    
    func clear() {
        ingredients = []
    }
    
    func addIngredient(_ ingredient: String) {
        ingredients.append(ingredient)
    }
    
//    static func initTest() -> Search {
//        let search = Search()
//        search.addIngredient("egg")
//        search.addIngredient("salad")
//        search.addIngredient("tomato")
//        search.addIngredient("corn")
//        return search
//    }
}
