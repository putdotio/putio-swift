import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getTunnelRoutes(completion: @escaping (_ routes: [PutioTunnel]?, _ error: Error?) -> Void) {
        let URL = "/tunnel/routes"

        self.get(URL)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                let routes = response!["routes"].arrayValue.map {PutioTunnel(json: $0)}

                return completion(routes, nil)
        }
    }

    public func setTunnelRoute(routeName: String, completion: PutioAPIBoolCompletion) {
        let URL = "/account/settings"
        let body = ["tunnel_route_name": routeName]

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
}
