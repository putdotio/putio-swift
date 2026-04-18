import SwiftyJSON

open class PutioRSSFilterPausedEvent: PutioHistoryEvent {
    open var rssFilterID: Int
    open var rssFilterTitle: String
    
    override init(json: JSON) {
        self.rssFilterID = json["rss_filter_id"].intValue
        self.rssFilterTitle = json["rss_filter_title"].stringValue
        
        super.init(json: json)
        
        self.type = .rssFilterPaused
    }
}
