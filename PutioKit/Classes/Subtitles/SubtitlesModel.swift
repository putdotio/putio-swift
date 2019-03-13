//
//  SubtitlesModel.swift
//  Putio
//
//  Created by Altay Aydemir on 22.12.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PutioSubtitle {
    var key: String
    var language: String
    var languageCode: String
    var name: String
    var source: String
    var url: String

    init(json: JSON) {
        self.key = json["key"].stringValue
        self.language = json["language"].stringValue
        self.languageCode = json["language_code"].stringValue
        self.name = json["name"].stringValue
        self.source = json["source"].stringValue
        self.url = json["url"].stringValue
    }
}
