import Foundation

extension PutioSDK {
    public func sendIFTTTEvent(event: PutioIFTTTEvent, completion: @escaping PutioSDKBoolCompletion) {
        self.post("/ifttt-client/event", body: ["event_type": event.eventType, "ingredients": event.ingredients.toJSON()]) { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
