import Foundation
import SwiftyJSON

open class PutioMp4Conversion {
    public enum Status: String {
        case queued = "IN_QUEUE",
            converting = "CONVERTING",
            completed = "COMPLETED",
            error = "ERROR"
    }

    open var percentDone: Float
    open var status: Status

    init(json: JSON) {
        let mp4 = json["mp4"]
        self.percentDone = mp4["percent_done"].floatValue / 100
        self.status = Status.init(rawValue: mp4["status"].stringValue)!
    }
}
