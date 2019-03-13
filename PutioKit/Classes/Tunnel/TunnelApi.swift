//
//  TunnelApi.swift
//  Putio
//
//  Created by Altay Aydemir on 9.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

extension PutioKit {
    func getTunnelRoutes(completion: @escaping (_ routes: [PutioTunnel]?, _ error: Error?) -> Void) {
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

    func setTunnelRoute(routeName: String, completion: PutioKitBoolCompletion) {
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
