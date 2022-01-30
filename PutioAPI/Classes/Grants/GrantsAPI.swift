import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getGrants(completion: @escaping (Result<[PutioOAuthGrant], PutioAPIError>) -> Void) {
        let url = "/oauth/grants"

        self.get(url)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["apps"].arrayValue.map {PutioOAuthGrant(json: $0)}))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func revokeGrant(id: Int, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/oauth/grants/\(id)/delete"

        self.post(url)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func linkDevice(code: String, completion: @escaping (Result<PutioOAuthGrant, PutioAPIError>) -> Void) {
        let URL = "/oauth2/oob/code"
        let body = ["code": code]

        self.post(URL)
            .send(body)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(PutioOAuthGrant(json: json["app"])))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }
}
