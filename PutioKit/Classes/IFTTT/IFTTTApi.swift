//
//  IFTTTApi.swift
//  Putio
//
//  Created by Altay Aydemir on 6.06.2018.
//  Copyright © 2018 Put.io. All rights reserved.
//

import Foundation

extension PutioKit {
    func sendIFTTTEvent(event: PutioIFTTTEvent, completion: PutioKitBoolCompletion) {
        let url = "/ifttt-client/event"
        let body = [
            "event_type": event.eventType,
            "ingredients": event.ingredients.toJSON()
        ] as [String: Any]

        self.post(url)
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
