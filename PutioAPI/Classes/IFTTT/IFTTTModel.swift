//
//  IFTTTModel.swift
//  Putio
//
//  Created by Altay Aydemir on 6.06.2018.
//  Copyright © 2018 Put.io. All rights reserved.
//

import Foundation

public class PutioIFTTTEvent {
    public class Ingredients {
        func toJSON() -> [String: Any] {
            return [:]
        }
    }

    open var eventType: String
    open var ingredients: Ingredients

    init(eventType: String, ingredients: Ingredients) {
        self.eventType = eventType
        self.ingredients = ingredients
    }
}

public class PutioIFTTTPlaybackEvent: PutioIFTTTEvent {
    public class PlaybackEventIngredients: PutioIFTTTEvent.Ingredients {
        open var fileId: Int
        open var fileName: String
        open var fileType: String

        init(fileId: Int, fileName: String, fileType: String) {
            self.fileId = fileId
            self.fileName = fileName
            self.fileType = fileType
        }

        override func toJSON() -> [String: Any] {
            return [
                "file_id": self.fileId,
                "file_name": self.fileName,
                "file_type": self.fileType
            ]
        }
    }

    init(eventType: String, ingredients: PlaybackEventIngredients) {
        super.init(eventType: eventType, ingredients: ingredients)
    }
}
