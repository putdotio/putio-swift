import Foundation
import SwiftyJSON

extension PutioAPI {
    public func listTrash(perPage: Int = 50, completion: @escaping (_ result: PutioListTrashResponse?, _ error: Error? ) -> Void) {
        let URL = "/trash/list"
        let query = ["per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end { (json, error) in
                guard let json = json, error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioListTrashResponse(json: json), nil)
            }
    }

    public func continueListTrash(cursor: String, perPage: Int = 50, completion: @escaping (_ result: PutioListTrashResponse?, _ error: Error? ) -> Void) {
        let URL = "/trash/list/continue"
        let query = ["cursor": cursor, "per_page": perPage] as [String : Any]

        self.get(URL)
            .query(query)
            .end { (json, error) in
                guard let json = json, error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioListTrashResponse(json: json), nil)
            }
    }

    public func restoreTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: PutioAPIBoolCompletion) {
        let URL = "/trash/restore"
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post(URL)
            .send(body)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }

    }

    public func deleteTrashFiles(fileIDs: [Int] = [], cursor: String?, completion: PutioAPIBoolCompletion) {
        let URL = "/trash/delete"
        var body: [String: Any] = [:]

        if let cursor = cursor, cursor != "" {
            body = ["cursor": cursor]
        } else {
            body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]
        }

        self.post(URL)
            .send(body)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    public func emptyTrash(completion: PutioAPIBoolCompletion) {
        let URL = "/trash/empty"

        self.post(URL)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }
}
