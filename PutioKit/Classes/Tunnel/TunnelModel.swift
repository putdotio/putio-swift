//
//  TunnelModel.swift
//  Putio
//
//  Created by Altay Aydemir on 9.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PutioTunnel {
    let name: String
    let description: String
    let hosts: [String]

    init(json: JSON) {
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.hosts = json["hosts"].arrayValue.map {$0.stringValue}
    }
}
