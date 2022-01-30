import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getHistoryEvents(completion: @escaping (Result<[PutioHistoryEvent], PutioAPIError>) -> Void) {
        let URL = "/events/list"

        self.get(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json["events"].arrayValue.map {PutioHistoryEventFactory.get(json: $0)}))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func clearHistoryEvents(completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/events/delete"

        self.post(URL)
            .end({ result in
                switch result {
                case .success(let json):
                    return completion(.success(json))
                case .failure(let error):
                    return completion(.failure(error))
                }
            })
    }

    public func deleteHistoryEvent(eventID: Int, completion: @escaping PutioAPIBoolCompletion) {
        let URL = "/events/delete/\(eventID)"

        self.post(URL)
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
