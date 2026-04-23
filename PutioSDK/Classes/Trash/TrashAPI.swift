import Foundation
import Alamofire

extension PutioSDK {
    public func listTrash(perPage: Int = 50) async throws -> PutioListTrashResponse {
        try await request("/trash/list", query: ["per_page": perPage], as: PutioListTrashResponse.self)
    }

    public func listTrash(perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await listTrash(perPage: perPage)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/trash/list", method: .get, query: ["per_page": perPage])), unknownError: error)))
            }
        }
    }

    public func continueListTrash(cursor: String, perPage: Int = 50) async throws -> PutioListTrashResponse {
        try await request("/trash/list/continue", query: ["cursor": cursor, "per_page": perPage], as: PutioListTrashResponse.self)
    }

    public func continueListTrash(cursor: String, perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await continueListTrash(cursor: cursor, perPage: perPage)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/trash/list/continue", method: .get, query: ["cursor": cursor, "per_page": perPage])), unknownError: error)))
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

    public func restoreTrashFiles(fileIDs: [Int] = [], cursor: String?) async throws -> PutioOKResponse {
        let body = putioTrashMutationBody(fileIDs: fileIDs, cursor: cursor)
        return try await request("/trash/restore", method: .post, body: body, as: PutioOKResponse.self)
    }

    public func deleteTrashFiles(fileIDs: [Int] = [], cursor: String?) async throws -> PutioOKResponse {
        let body = putioTrashMutationBody(fileIDs: fileIDs, cursor: cursor)
        return try await request("/trash/delete", method: .post, body: body, as: PutioOKResponse.self)
    }
}

private func putioTrashMutationBody(fileIDs: [Int], cursor: String?) -> Parameters {
    if let cursor, !cursor.isEmpty {
        return ["cursor": cursor]
    }

    return ["file_ids": (fileIDs.map { String($0) }).joined(separator: ",")]
}
