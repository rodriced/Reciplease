//
//  MockStoreService.swift
//  RecipleaseTests
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//
@testable import Reciplease

import Foundation

class MockIdsStore: IdsStoreProto {
    enum Err: Error {
        case StoreError
    }
    
    var store: Set<String>
    var errorThrown: Bool
    
    init(store: Set<String> = Set(), errorThrown: Bool = false) {
        self.store = store
        self.errorThrown = errorThrown
    }
    func load() async throws -> [String] {
        guard !errorThrown else {throw Err.StoreError}
        return Array(store)
    }
    func add(_ id: String) async throws {
        guard !errorThrown else {throw Err.StoreError}
        store.insert(id)
    }
    func remove(_ id: String) async throws {
        guard !errorThrown else {throw Err.StoreError}
        store.remove(id)
    }
}

