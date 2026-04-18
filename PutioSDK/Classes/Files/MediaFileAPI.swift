import Foundation
import SwiftyJSON

extension PutioAPI {
    public func startMp4Conversion(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/\(fileID)/mp4"

        self.post(url) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func getMp4ConversionStatus(fileID: Int, completion: @escaping (Result<PutioMp4Conversion, PutioAPIError>) -> Void) {
        let url = "/files/\(fileID)/mp4"

        self.get(url) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioMp4Conversion(json: json)))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func getStartFrom(fileID: Int, completion: @escaping (Result<Int, PutioAPIError>) -> Void) {
        let url = "/files/\(fileID)/start-from"

        self.get(url) { result in
            switch result {
            case .success(let json):
                return completion(.success(json["start_from"].intValue))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func setStartFrom(fileID: Int, time: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/\(fileID)/start-from/set"

        self.post(url, body: ["time": time]) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func resetStartFrom(fileID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/files/\(fileID)/start-from/delete"

        self.get(url) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
