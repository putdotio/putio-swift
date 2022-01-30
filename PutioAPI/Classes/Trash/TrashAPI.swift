import Foundation
import SwiftyJSON

extension PutioAPI {
    public func listTrash(perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioAPIError>) -> Void) {
        let URL = "/trash/list"
        let query = ["per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioListTrashResponse(json: json)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func continueListTrash(cursor: String, perPage: Int = 50, completion: @escaping (Result<PutioListTrashResponse, PutioAPIError>) -> Void) {
        let URL = "/trash/list/continue"
        let query = ["cursor": cursor, "per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioListTrashResponse(json: json)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func restoreTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/trash/restore"
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post(URL)
            .send(body)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })

    }

    public func deleteTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/trash/delete"
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post(URL)
            .send(body)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func emptyTrash(completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/trash/empty"

        self.post(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }
}
