import Foundation
import SwiftyJSON

extension PutioSDK {
    public func getHistoryEvents(completion: @escaping (Result<[PutioHistoryEvent], PutioSDKError>) -> Void) {
        self.get("/events/list") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["events"].arrayValue.map {PutioHistoryEventFactory.get(json: $0)}))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func clearHistoryEvents(completion: @escaping PutioSDKBoolCompletion) {
        self.post("/events/delete") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func deleteHistoryEvent(eventID: Int, completion: @escaping PutioSDKBoolCompletion) {
        self.post("/events/delete/\(eventID)") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
}
