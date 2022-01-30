import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getFiles(parentID: Int, query: PutioAPIQuery = [:], completion: @escaping (Result<(parent: PutioFile, children: [PutioFile]), PutioAPIError>) -> Void) {
        let URL = "/files/list"
        let query = query.merge(with: [
            "parent_id": parentID,
            "mp4_status_parent": 1,
            "stream_url_parent": 1,
            "mp4_stream_url_parent": 1,
            "video_metadata_parent": 1
        ])

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success((parent: PutioFile(json: json["parent"]), children: json["files"].arrayValue.map {PutioFile(json: $0)})))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func getFile(fileID: Int, query: PutioAPIQuery = [:], completion: @escaping (Result<PutioFile, PutioAPIError>) -> Void) {
        let URL = "/files/\(fileID)"
        let query = query.merge(with: [
            "mp4_size": 1,
            "start_from": 1,
            "stream_url": 1,
            "mp4_stream_url": 1
        ])

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioFile(json: json)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func deleteFile(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.deleteFiles(fileIDs: [fileID], completion: completion)
    }

    public func deleteFiles(fileIDs: [Int], query: PutioAPIQuery = [:], completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/delete"
        let query = ["skip_nonexistents": true, "skip_owner_check": false].merge(with: query)
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

        self.post(URL)
            .query(query)
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

    public func copyFile(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.copyFiles(fileIDs: [fileID], completion: completion)
    }

    public func copyFiles(fileIDs: [Int], completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/copy-to-disk"
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

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

    public func moveFile(fileID: Int, parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.moveFiles(fileIDs: [fileID], parentID: parentID, completion: completion)
    }

    public func moveFiles(fileIDs: [Int], parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/move"
        let body = [
            "file_ids": (fileIDs.map {String($0)}).joined(separator: ","),
            "parent_id": parentID
        ] as [String: Any]

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

    public func renameFile(fileID: Int, name: String, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/rename/"
        let body = ["file_id": fileID, "name": name] as [String: Any]

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

    public func createFolder(name: String, parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/create-folder"
        let body = ["name": name, "parent_id": parentID] as [String: Any]

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

    public func findNextFile(fileID: Int, fileType: PutioNextFileType, completion: @escaping (Result<PutioNextFile, PutioAPIError>) -> Void) {
        let URL = "/files/\(fileID)/next-file"
        let query = ["file_type": fileType.rawValue]

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioNextFile(json: json, type: fileType)))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }
    
    public func setSortBy(fileId: Int, sortBy: String, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/set-sort-by"
        let body = ["file_id": fileId, "sort_by": sortBy] as [String: Any]
        
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

    public func resetFileSpecificSortSettings(completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/files/remove-sort-by-settings"

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
