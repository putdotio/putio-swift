import Foundation
import Alamofire
import SwiftyJSON

extension PutioSDK {
    public func getFiles(parentID: Int, query: Parameters = [:]) async throws -> PutioFilesListResult {
        let query = query.merge(with: [
            "parent_id": parentID,
            "mp4_status_parent": 1,
            "stream_url_parent": 1,
            "mp4_stream_url_parent": 1,
            "video_metadata_parent": 1
        ])

        let envelope = try await request("/files/list", query: query, as: PutioFilesListEnvelope.self)
        return PutioFilesListResult(parent: envelope.parent, children: envelope.files, cursor: envelope.cursor, total: envelope.total)
    }

    public func getFiles(parentID: Int, query: Parameters = [:], completion: @escaping (Result<(parent: PutioFile?, children: [PutioFile]), PutioSDKError>) -> Void) {
        Task {
            do {
                let response = try await getFiles(parentID: parentID, query: query)
                completion(.success((parent: response.parent, children: response.children)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/list", method: .get, query: query)), unknownError: error)))
            }
        }
    }

    public func getFile(fileID: Int, query: Parameters = [:]) async throws -> PutioFile {
        let query = query.merge(with: [
            "mp4_size": 1,
            "start_from": 1,
            "stream_url": 1,
            "mp4_stream_url": 1
        ])

        let envelope = try await request("/files/\(fileID)", query: query, as: PutioFileEnvelope.self)
        return envelope.file
    }

    public func getFile(fileID: Int, query: Parameters = [:], completion: @escaping (Result<PutioFile, PutioSDKError>) -> Void) {
        Task {
            do {
                completion(.success(try await getFile(fileID: fileID, query: query)))
            } catch let error as PutioSDKError {
                completion(.failure(error))
            } catch {
                completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: PutioSDKRequestConfig(apiConfig: config, url: "/files/\(fileID)", method: .get, query: query)), unknownError: error)))
            }
        }
    }

    public func deleteFile(fileID: Int, completion: @escaping PutioSDKBoolCompletion) {
        return self.deleteFiles(fileIDs: [fileID], completion: completion)
    }

    public func deleteFiles(fileIDs: [Int], query: Parameters = [:], completion: @escaping PutioSDKBoolCompletion) {
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

    public func copyFile(fileID: Int, completion: @escaping PutioSDKBoolCompletion) {
        return self.copyFiles(fileIDs: [fileID], completion: completion)
    }

    public func copyFiles(fileIDs: [Int], completion: @escaping PutioSDKBoolCompletion) {
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

    public func moveFile(fileID: Int, parentID: Int, completion: @escaping PutioSDKBoolCompletion) {
        return self.moveFiles(fileIDs: [fileID], parentID: parentID, completion: completion)
    }

    public func moveFiles(fileIDs: [Int], parentID: Int, completion: @escaping PutioSDKBoolCompletion) {
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

    public func renameFile(fileID: Int, name: String, completion: @escaping PutioSDKBoolCompletion) {
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

    public func createFolder(name: String, parentID: Int, completion: @escaping PutioSDKBoolCompletion) {
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

    public func createFolder(name: String, parentID: Int) async throws -> PutioFile {
        let body = ["name": name, "parent_id": parentID] as Parameters
        let envelope = try await request("/files/create-folder", method: .post, body: body, as: PutioFileEnvelope.self)
        return envelope.file
    }

    public func deleteFiles(fileIDs: [Int], query: Parameters = [:]) async throws -> PutioOKResponse {
        let query = ["skip_nonexistents": true, "skip_owner_check": false].merge(with: query)
        let body = ["file_ids": (fileIDs.map { String($0) }).joined(separator: ",")]
        return try await request("/files/delete", method: .post, query: query, body: body, as: PutioOKResponse.self)
    }

    public func findNextFile(fileID: Int, fileType: PutioNextFileType, completion: @escaping (Result<PutioNextFile, PutioSDKError>) -> Void) {
        let url = "/files/\(fileID)/next-file"
        let query = ["file_type": fileType.rawValue]

        self.get(url, query: query) { result in
            switch result {
            case .success(let json):
                do {
                    let data = try json["next_file"].rawData()
                    let nextFile = try JSONDecoder().decode(PutioNextFile.self, from: data)
                    return completion(.success(nextFile))
                } catch {
                    let requestConfig = PutioSDKRequestConfig(apiConfig: self.config, url: url, method: .get, query: query)
                    return completion(.failure(PutioSDKError(request: PutioSDKErrorRequestInformation(config: requestConfig), decodingError: error, responseBody: json["next_file"].rawString() ?? "")))
                }
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    public func setSortBy(fileId: Int, sortBy: String, completion: @escaping PutioSDKBoolCompletion) {
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

    public func resetFileSpecificSortSettings(completion: @escaping PutioSDKBoolCompletion) {
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

public struct PutioFilesListResult {
    public let parent: PutioFile?
    public let children: [PutioFile]
    public let cursor: String?
    public let total: Int?
}

private struct PutioFilesListEnvelope: Decodable {
    let parent: PutioFile?
    let files: [PutioFile]
    let cursor: String?
    let total: Int?
}

private struct PutioFileEnvelope: Decodable {
    let file: PutioFile
}
