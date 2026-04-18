import Foundation
import SwiftyJSON

extension PutioSDK {
    public func listTrash(perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioSDKError>) -> Void) {
        self.get("/trash/list", query: ["per_page": perPage]) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioListTrashResponse(json: json)))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func continueListTrash(cursor: String, perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioSDKError>) -> Void) {
        self.get("/trash/list/continue", query: ["cursor": cursor, "per_page": perPage]) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioListTrashResponse(json: json)))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func restoreTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: @escaping PutioSDKBoolCompletion) {
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post("/trash/restore", body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func deleteTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: @escaping PutioSDKBoolCompletion) {
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post("/trash/delete", body: body){ result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func emptyTrash(completion: @escaping PutioSDKBoolCompletion) {
        self.post("/trash/empty") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
