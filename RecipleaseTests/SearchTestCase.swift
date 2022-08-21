//
//  SearchTestCase.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 13/08/2022.
//

@testable import Reciplease

import XCTest

class SearchTestCase: XCTestCase {
    override func setUp() {
        Task {
            try await FavoriteRecipes.shared.setIdsStore(MockIdsStore())
        }
    }

    func testSearch() throws {
        let search = Search()

        XCTAssertTrue(search.isEmpty)

        search.addIngredient("salad")
        search.addIngredient("chicken")

        XCTAssertEqual(search.ingredients, ["salad", "chicken"])
        XCTAssertFalse(search.isEmpty)

        search.clear()
        
        XCTAssertEqual(search.ingredients, [])
        XCTAssertTrue(search.isEmpty)
    }
}
