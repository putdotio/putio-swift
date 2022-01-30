import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getGrants(completion: @escaping (_ routes: [PutioOAuthGrant]?, _ error: PutioAPIError?) -> Void) {
        let url = "/oauth/grants"

        self.get(url)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                let apps = response!["apps"].arrayValue.map {PutioOAuthGrant(json: $0)}

                return completion(apps, nil)
        }
    }

    public func revokeGrant(id: Int, completion: PutioAPIBoolCompletion) {
        let url = "/oauth/grants/\(id)/delete"

        self.post(url)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    public func linkDevice(code: String, completion: @escaping (_ success: PutioOAuthGrant?, _ error: PutioAPIError?) -> Void) {
        let URL = "/oauth2/oob/code"
        let body = ["code": code]

        self.post(URL)
            .send(body)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioOAuthGrant(json: response!["app"]), nil)
        }
    }
}
