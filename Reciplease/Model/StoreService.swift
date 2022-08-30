//
//  StoreService.swift
//  Reciplease
//
//  Created by Rodolphe Desruelles on 08/08/2022.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

protocol IdsStoreProto {
    func addListener(_ snapshotHandler: @escaping ([String]?) -> Void)
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
    
    func addListener(_ snapshotHandler: @escaping ([String]?) -> Void) {
        store.collection(collectionName).addSnapshotListener {
            (querySnapshot, error) in
//            print("IdsStore -> listener")
            if let error = error {
                print("IdsStore listener error : \(String(describing: error))")
                return
            }
            
            if querySnapshot!.metadata.hasPendingWrites || querySnapshot!.metadata.isFromCache {
                // If change came from local then ids are already up to date
                snapshotHandler(nil)
            } else {
                let ids = querySnapshot!.documents.map { $0.documentID }
                snapshotHandler(ids)
            }
        }
    }

    func load() async throws -> [String] {
        let snapshot = try await store.collection(collectionName).getDocuments()
        return snapshot.documents.map { $0.documentID }
    }
    
    func add(_ id: String) async throws {
        try await store.collection(collectionName).document(id).setData([:])
    }
    
    func remove(_ id: String) async throws {
        try await store.collection(collectionName).document(id).delete()
    }
}
