import Foundation

extension PutioAPI {
    public func sendIFTTTEvent(event: PutioIFTTTEvent, completion: @escaping PutioAPIBoolCompletion) {
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
