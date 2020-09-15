//
//  FileHistoryEventInterface.swift
//  PutioAPI
//
//  Created by Batuhan Aksoy on 15.09.2020.
//

import Foundation
import SwiftyJSON

open class PutioFileHistoryEvent: PutioHistoryEvent {
    open var fileID: Int
    override public init(json: JSON) {
        self.fileID = 0
        
        super.init(json: json)
    }
}
