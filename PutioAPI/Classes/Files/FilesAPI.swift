import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getFiles(parentID: Int, query: PutioAPIQuery = [:], completion: @escaping (_ parent: PutioFile?, _ children: [PutioFile]?, _ error: Error?) -> Void) {
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
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, nil, error)
                }

                let parent = PutioFile(json: response!["parent"])
                let children = response!["files"].arrayValue.map {PutioFile(json: $0)}

                return completion(parent, children, nil)
        }
    }

    public func getFile(fileID: Int, query: PutioAPIQuery = [:], completion: @escaping (_ file: PutioFile?, _ error: Error?) -> Void) {
        let URL = "/files/\(fileID)"
        let query = query.merge(with: [
            "mp4_size": 1,
            "start_from": 1,
            "stream_url": 1,
            "mp4_stream_url": 1
        ])

        self.get(URL)
            .query(query)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioFile(json: response!["file"]), nil)
        }
    }

    public func deleteFile(fileID: Int, completion: PutioAPIBoolCompletion) {
        return self.deleteFiles(fileIDs: [fileID], completion: completion)
    }

    public func deleteFiles(fileIDs: [Int], query: PutioAPIQuery = [:], completion: PutioAPIBoolCompletion) {
        let URL = "/files/delete"
        let query = ["skip_nonexistents": true, "skip_owner_check": false].merge(with: query)
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

        self.post(URL)
            .query(query)
            .send(body)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    public func copyFile(fileID: Int, completion: PutioAPIBoolCompletion) {
        return self.copyFiles(fileIDs: [fileID], completion: completion)
    }

    public func copyFiles(fileIDs: [Int], completion: PutioAPIBoolCompletion) {
        let URL = "/files/copy-to-disk"
        let body = ["file_ids": (fileIDs.map {String($0)}).joined(separator: ",")]

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

    public func moveFile(fileID: Int, parentID: Int, completion: PutioAPIBoolCompletion) {
        return self.moveFiles(fileIDs: [fileID], parentID: parentID, completion: completion)
    }

    public func moveFiles(fileIDs: [Int], parentID: Int, completion: PutioAPIBoolCompletion) {
        let URL = "/files/move"
        let body = [
            "file_ids": (fileIDs.map {String($0)}).joined(separator: ","),
            "parent_id": parentID
        ] as [String: Any]

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

    public func renameFile(fileID: Int, name: String, completion: PutioAPIBoolCompletion) {
        let URL = "/files/rename/"
        let body = ["file_id": fileID, "name": name] as [String: Any]

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

    public func createFolder(name: String, parentID: Int, completion: PutioAPIBoolCompletion) {
        let URL = "/files/create-folder"
        let body = ["name": name, "parent_id": parentID] as [String: Any]

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

    public func findNextFile(fileID: Int, fileType: PutioNextFileType, completion: @escaping (_ file: PutioNextFile?, _ error: Error?) -> Void) {
        let URL = "/files/\(fileID)/next-file"
        let query = ["file_type": fileType.rawValue]

        self.get(URL)
            .query(query)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioNextFile(json: response!["next_file"], type: fileType), nil)
            }
    }
    
    public func setSortBy(fileId: Int, sortBy: String, completion: PutioAPIBoolCompletion) {
        let URL = "/files/set-sort-by"
        let body = ["file_id": fileId, "sort_by": sortBy] as [String: Any]
        
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
}
