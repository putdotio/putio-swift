//
//  FilesApi.swift
//  Putio
//
//  Created by Altay Aydemir on 2.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

extension PutioKit {
    func getFiles(parentID: Int, query: Query = [:], completion: @escaping (_ parent: PutioFile?, _ children: [PutioFile]?, _ error: Error?) -> Void) {
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

    func getFile(fileID: Int, query: Query = [:], completion: @escaping (_ file: PutioFile?, _ error: Error?) -> Void) {
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

    func searchFiles(query: String, page: Int = 1, completion: @escaping (_ files: [PutioFile]?, _ error: Error?) -> Void) {
        let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let URL = "/files/search/\(safeQuery)/page/\(page)"

        self.get(URL)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                let files = response!["files"].arrayValue.map {PutioFile(json: $0)}

                return completion(files, nil)
        }
    }

    func deleteFile(fileID: Int, completion: PutioKitBoolCompletion) {
        return self.deleteFiles(fileIDs: [fileID], completion: completion)
    }

    func deleteFiles(fileIDs: [Int], query: Query = [:], completion: PutioKitBoolCompletion) {
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

    func copyFile(fileID: Int, completion: PutioKitBoolCompletion) {
        return self.copyFiles(fileIDs: [fileID], completion: completion)
    }

    func copyFiles(fileIDs: [Int], completion: PutioKitBoolCompletion) {
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

    func moveFile(fileID: Int, parentID: Int, completion: PutioKitBoolCompletion) {
        return self.moveFiles(fileIDs: [fileID], parentID: parentID, completion: completion)
    }

    func moveFiles(fileIDs: [Int], parentID: Int, completion: PutioKitBoolCompletion) {
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

    func renameFile(fileID: Int, name: String, completion: PutioKitBoolCompletion) {
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

    func createFolder(name: String, parentID: Int, completion: PutioKitBoolCompletion) {
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

    func findNextFile(fileID: Int, fileType: String, completion: @escaping (_ file: PutioNextFile?, _ error: Error?) -> Void) {
        let URL = "/files/\(fileID)/next-file"
        let query = ["file_type": fileType]

        self.get(URL)
            .query(query)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioNextFile(json: response!["next_file"]), nil)
            }
    }
}
