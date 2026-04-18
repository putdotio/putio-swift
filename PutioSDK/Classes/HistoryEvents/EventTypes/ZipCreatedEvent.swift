import SwiftyJSON

open class PutioZipCreatedEvent: PutioHistoryEvent {
    open var zipID: Int
    open var zipSize: Int64
    
    override init(json: JSON) {
        self.zipID = json["zip_id"].intValue
        self.zipSize = json["zip_size"].int64Value
        
        super.init(json: json)
        
        self.type = .zipCreated
    }
}
