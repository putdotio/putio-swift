//
//  VideoFileApi.swift
//  Putio
//
//  Created by Altay Aydemir on 21.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation
import SwiftyJSON

extension PutioKit {
    func startMp4Conversion(fileID: Int, completion: PutioKitBoolCompletion) {
        let URL = "/files/\(fileID)/mp4"

        self.post(URL)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    func getMp4ConversionStatus(fileID: Int, completion: @escaping (_ status: PutioMp4Conversion?, _ error: Error?) -> Void) {
        let URL = "/files/\(fileID)/mp4"

        self.get(URL)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                return completion(PutioMp4Conversion(json: response!), nil)
        }
    }

    func setStartFrom(fileID: Int, time: Int, completion: PutioKitBoolCompletion) {
        let URL = "/files/\(fileID)/start-from/set"

        self.post(URL)
            .send(["time": time])
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    func resetStartFrom(fileID: Int, completion: PutioKitBoolCompletion) {
        let URL = "/files/\(fileID)/start-from/delete"

        self.get(URL)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }
}
