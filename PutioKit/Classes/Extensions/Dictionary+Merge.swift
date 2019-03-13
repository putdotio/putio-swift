//
//  Dictionary+Merge.swift
//  Putio
//
//  Created by Altay Aydemir on 2.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation

extension Dictionary {
    func merge(with source: [Key: Value]) -> Dictionary {
        var result: [Key: Value] = [:]

        for (key, value) in self {
            result[key] = value
        }

        for (key, value) in source {
            result[key] = value
        }

        return result
    }
}
