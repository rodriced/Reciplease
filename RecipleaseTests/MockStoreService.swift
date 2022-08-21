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
    
    var data: Set<String>
    var errorThrown: Bool
    
    func addListener(_ handler: @escaping ([String]?) -> Void) {}
    
    init(store: Set<String> = Set(), errorThrown: Bool = false) {
        self.data = store
        self.errorThrown = errorThrown
    }
    func load() async throws -> [String] {
        guard !errorThrown else {throw Err.StoreError}
        return Array(data)
    }
    func add(_ id: String) async throws {
        guard !errorThrown else {throw Err.StoreError}
        data.insert(id)
    }
    func remove(_ id: String) async throws {
        guard !errorThrown else {throw Err.StoreError}
        data.remove(id)
    }
}

