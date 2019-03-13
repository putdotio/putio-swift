//
//  UserApi.swift
//  Putio
//
//  Created by Altay Aydemir on 26.10.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getUserInfo(query: PutioAPIQuery, completion: @escaping (_ user: PutioUser?, _ error: Error?) -> Void) {
        let URL = "/account/info"

        self.get(URL)
            .query(query)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioUser(json: response!), nil)
        }
    }

    public func getSettings(completion: @escaping (_ settings: PutioUser.Settings?, _ error: Error?) -> Void) {
        let URL = "/account/settings"

        self.get(URL)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioUser.Settings(json: response!), nil)
        }
    }

    public func saveSettings(body: [String: String], completion: PutioAPIBoolCompletion) {
        let URL = "/account/settings"

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
