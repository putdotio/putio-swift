import Foundation
import SwiftyJSON

extension PutioSDK {
    public func getGrants(completion: @escaping (Result<[PutioOAuthGrant], PutioSDKError>) -> Void) {
        self.get("/oauth/grants") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["apps"].arrayValue.map {PutioOAuthGrant(json: $0)}))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func revokeGrant(id: Int, completion: @escaping PutioSDKBoolCompletion) {
        self.post("/oauth/grants/\(id)/delete") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func linkDevice(code: String, completion: @escaping (Result<PutioOAuthGrant, PutioSDKError>) -> Void) {
        self.post("/oauth2/oob/code", body: ["code": code]) { result in
            switch result {
            case .success(let json):
                return completion(.success(PutioOAuthGrant(json: json["app"])))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
