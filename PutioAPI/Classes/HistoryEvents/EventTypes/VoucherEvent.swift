import SwiftyJSON

open class PutioVoucherEvent: PutioHistoryEvent {
    open var voucherID: Int
    open var voucherOwnerID: Int
    open var voucherOwnerName: String
    
    override init(json: JSON) {
        self.voucherID = json["voucher"].intValue
        self.voucherOwnerID = json["voucher_owner_id"].intValue
        self.voucherOwnerName = json["voucher_owner_name"].stringValue
        
        super.init(json: json)
        
        self.type = .voucher
    }
}
