import Foundation
import Alamofire
import SwiftyJSON

extension PutioAPI {
    public func getFiles(parentID: Int, query: Parameters = [:], completion: @escaping (Result<(parent: PutioFile, children: [PutioFile]), PutioAPIError>) -> Void) {
        let url = "/files/list"
        let query = query.merge(with: [
            "parent_id": parentID,
            "mp4_status_parent": 1,
            "stream_url_parent": 1,
            "mp4_stream_url_parent": 1,
            "video_metadata_parent": 1
        ])

        self.get(url, query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success((parent: PutioFile(json: json["parent"]), children: json["files"].arrayValue.map {PutioFile(json: $0)})))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func getFile(fileID: Int, query: Parameters = [:], completion: @escaping (Result<PutioFile, PutioAPIError>) -> Void) {
        let url = "/files/\(fileID)"
        let query = query.merge(with: [
            "mp4_size": 1,
            "start_from": 1,
            "stream_url": 1,
            "mp4_stream_url": 1
        ])

        self.get(url, query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioFile(json: json["file"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func deleteFile(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.deleteFiles(fileIDs: [fileID], completion: completion)
    }

    public func deleteFiles(fileIDs: [Int], query: Parameters = [:], completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/delete"
        let query = ["skip_nonexistents": true, "skip_owner_check": false].merge(with: query)
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

        self.post(url, query: query, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func copyFile(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.copyFiles(fileIDs: [fileID], completion: completion)
    }

    public func copyFiles(fileIDs: [Int], completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/copy-to-disk"
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

        self.post(url, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func moveFile(fileID: Int, parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        return self.moveFiles(fileIDs: [fileID], parentID: parentID, completion: completion)
    }

    public func moveFiles(fileIDs: [Int], parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/move"
        let body = [
            "file_ids": (fileIDs.map {String($0)}).joined(separator: ","),
            "parent_id": parentID
        ] as [String: Any]

        self.post(url, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func renameFile(fileID: Int, name: String, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/rename/"
        let body = ["file_id": fileID, "name": name] as [String: Any]

        self.post(url, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func createFolder(name: String, parentID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/create-folder"
        let body = ["name": name, "parent_id": parentID] as [String: Any]

        self.post(url, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func findNextFile(fileID: Int, fileType: PutioNextFileType, completion: @escaping (Result<PutioNextFile, PutioAPIError>) -> Void) {
        let url = "/files/\(fileID)/next-file"
        let query = ["file_type": fileType.rawValue]

        self.get(url, query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioNextFile(json: json["next_file"], type: fileType)))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    public func setSortBy(fileId: Int, sortBy: String, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/set-sort-by"
        let body = ["file_id": fileId, "sort_by": sortBy] as [String: Any]
        
        self.post(url, body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func resetFileSpecificSortSettings(completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/remove-sort-by-settings"

        self.post(url) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
