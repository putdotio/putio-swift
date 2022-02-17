import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getHistoryEvents(completion: @escaping (Result<[PutioHistoryEvent], PutioAPIError>) -> Void) {
        self.get("/events/list") { result in
            switch result {
            case .success(let json):
                return completion(.success(json["events"].arrayValue.map {PutioHistoryEventFactory.get(json: $0)}))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func clearHistoryEvents(completion: @escaping PutioAPIBoolCompletion) {
        self.post("/events/delete") { result in
            switch result {
            case .success(let json):
                return completion(.success(json))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }

    public func deleteHistoryEvent(eventID: Int, completion: @escaping PutioAPIBoolCompletion) {
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
