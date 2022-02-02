import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getAccountInfo(query: PutioAPIQuery = [:], completion: @escaping (Result<PutioAccount, PutioAPIError>) -> Void) {
        let URL = "/account/info"

        self.get(URL)
            .query(query)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioAccount(json: json["info"])))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func getAccountSettings(completion: @escaping (Result<PutioAccount.Settings, PutioAPIError>) -> Void) {
        let URL = "/account/settings"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioAccount.Settings(json: json["settings"])))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func saveAccountSettings(body: [String: Any], completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/account/settings"

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

    public func clearAccountData(options: [String: Bool], completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/account/clear"

        self.post(URL)
            .send(options)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func destroyAccount(currentPassword: String, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/account/destroy"
        let body = ["current_password": currentPassword]

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
}


