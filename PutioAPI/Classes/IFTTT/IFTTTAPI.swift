import Foundation

extension PutioAPI {
    public func sendIFTTTEvent(event: PutioIFTTTEvent, completion: @escaping PutioAPIBoolCompletion) {
        let url = "/ifttt-client/event"
        let body = [
            "event_type": event.eventType,
            "ingredients": event.ingredients.toJSON()
        ] as [String: Any]

        self.post(url)
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
