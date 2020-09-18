//
//  HistoryEventFactory.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 14.09.2020.
//

import SwiftyJSON

open class PutioHistoryEventFactory {
    static func get(json: JSON) -> PutioHistoryEvent {
        switch json["type"] {
        case "upload":
            return PutioUploadEvent(json: json)
        case "file_shared":
            return PutioFileSharedEvent(json: json)
        case "transfer_completed":
            return PutioTransferCompletedEvent(json: json)
        case "transfer_error":
            return PutioTransferErrorEvent(json: json)
        case "file_from_rss_deleted_for_space":
            return PutioFileFromRSSDeletedErrorEvent(json: json)
        case "rss_filter_paused":
            return PutioRSSFilterPausedEvent(json: json)
        case "transfer_from_rss_error":
            return PutioTransferFromRSSErrorEvent(json: json)
        case "transfer_callback_error":
            return PutioTransferCallbackErrorEvent(json: json)
        case "private_torrent_pin":
            return PutioPrivateTorrentPinEvent(json: json)
        case "voucher":
            return PutioVoucherEvent(json: json)
        case "zip_created":
            return PutioZipCreatedEvent(json: json)
        default:
            return PutioHistoryEvent(json: json)
        }
    }
}

