//
//  StoreService.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


protocol IdsStoreProto {
    func load() async throws -> [String]
    func add(_ id: String) async throws
    func remove(_ id: String) async throws
}

class IdsStore: IdsStoreProto {
    private let store = Firestore.firestore()
    
    private let collectionName: String
    
    init(_ collectionName: String) {
        self.collectionName = collectionName
    }

    func load() async throws -> [String] {
            let snapshot = try await store.collection(collectionName).getDocuments()
            return snapshot.documents.map {$0.documentID}
    }
    
    func add(_ id: String) async throws {
            try await store.collection(collectionName).document(id).setData([:])
    }
    
    func remove(_ id: String) async throws {
            try await store.collection(collectionName).document(id).delete()
    }
}
