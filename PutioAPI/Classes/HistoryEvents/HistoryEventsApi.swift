import Foundation
import SwiftyJSON

extension PutioAPI {
    public func getHistoryEvents(completion: @escaping (_ events: [PutioHistoryEvent]?, _ error: Error?) -> Void) {
        let URL = "/events/list"

        self.get(URL)
            .end { (response, error) in
                guard error == nil else {
                    return completion(nil, error)
                }

                let events = response!["events"].arrayValue.map {PutioHistoryEventFactory.get(json: $0)}

                return completion(events, nil)
        }
    }

    public func clearHistoryEvents(completion: PutioAPIBoolCompletion) {
        let URL = "/events/delete"

        self.post(URL)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }

    public func deleteHistoryEvent(eventID: Int, completion: PutioAPIBoolCompletion) {
        let URL = "/events/delete/\(eventID)"

        self.post(URL)
            .end { (_, error) in
                guard let completion = completion else { return }

                guard error == nil else {
                    return completion(false, error)
                }

                return completion(true, nil)
        }
    }
}
