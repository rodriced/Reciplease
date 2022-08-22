//
//  APIRequestLoader.swift
//  LeBaluchon
//
//  Created by Rodolphe Desruelles on 01/07/2022.
//

import Alamofire
import Foundation

protocol APIRequest {
    associatedtype InputDataType
    associatedtype DecodedDataType: Decodable
    associatedtype ResultDataType: Equatable

    func makeRequest(from inputData: InputDataType, with session: Session) throws -> DataRequest
    func extractResult(from decodedData: DecodedDataType) throws -> ResultDataType
}

extension APIRequest {
    func extractResult(from decodedData: DecodedDataType) throws -> ResultDataType where DecodedDataType == ResultDataType
    {
        decodedData
    }
}

class APIRequestLoader<T: APIRequest> {
    private let apiRequest: T
    private let session: Session

    init(apiRequest: T, session: Session = .default) {
        self.apiRequest = apiRequest
        self.session = session
    }

    func load(_ requestInputData: T.InputDataType) async throws -> T.ResultDataType? {
        guard let request = try? apiRequest.makeRequest(from: requestInputData, with: session) else {
            print("Error: bad request")
            return nil
        }

        return try await withCheckedThrowingContinuation() { continuation in
            request
                .validate()
                .responseDecodable(of: T.DecodedDataType.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        //                    debugPrint(recipesRequestData)
                        return continuation.resume(returning: try? self.apiRequest.extractResult(from: decodedData))
                    case .failure(let afError):
                        debugPrint(afError)
                        continuation.resume(throwing: afError)
                    }
                }
        }
    }
}
