import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getGrants(completion: @escaping (Result<[PutioOAuthGrant], PutioAPIError>) -> Void) {
        self.get("/oauth/grants") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["apps"].arrayValue.map {PutioOAuthGrant(json: $0)}))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func revokeGrant(id: Int, completion: @escaping PutioAPIBoolCompletion) {
        self.post("/oauth/grants/\(id)/delete") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func linkDevice(code: String, completion: @escaping (Result<PutioOAuthGrant, PutioAPIError>) -> Void) {
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
