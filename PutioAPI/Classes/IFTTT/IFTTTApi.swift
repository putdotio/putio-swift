import Foundation

extension PutioAPI {
    public func sendIFTTTEvent(event: PutioIFTTTEvent, completion: PutioAPIBoolCompletion) {
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
