import Foundation
import SwiftyJSON

open class PutioFileSearchResponse {
    open var cursor: String
    open var files: [PutioFile]

    init(json: JSON) {
        self.cursor = json["cursor"].stringValue
        self.files = json["files"].arrayValue.map {PutioFile(json: $0)}
    }
}
