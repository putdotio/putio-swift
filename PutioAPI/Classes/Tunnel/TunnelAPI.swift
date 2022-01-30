import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getTunnelRoutes(completion: @escaping (Result<[PutioTunnel], PutioAPIError>) -> Void) {
        let URL = "/tunnel/routes"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["routes"].arrayValue.map {PutioTunnel(json: $0)}))
                case .failure(let error):
                    return completion(.failure(error))

                }
            })
    }

    public func setTunnelRoute(routeName: String, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/account/settings"
        let body = ["tunnel_route_name": routeName]

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
