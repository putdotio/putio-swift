import Foundation
import Alamofire
import SwiftyJSON

extension PutioAPI {
    public func getAccountInfo(query: Parameters = [:], completion: @escaping (Result<PutioAccount, PutioAPIError>) -> Void) {
        self.get("/account/info", query: query) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioAccount(json: json["info"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func getAccountSettings(completion: @escaping (Result<PutioAccount.Settings, PutioAPIError>) -> Void) {
        self.get("/account/settings") { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioAccount.Settings(json: json["settings"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func saveAccountSettings(body: [String: Any], completion: @escaping PutioAPIBoolCompletion) {
        self.post("/account/settings", body: body) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func clearAccountData(options: [String: Bool], completion: @escaping PutioAPIBoolCompletion) {
        self.post("/account/clear", body: options) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func destroyAccount(currentPassword: String, completion: @escaping PutioAPIBoolCompletion) {
        self.post("/account/destroy", body: ["current_password": currentPassword]) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
