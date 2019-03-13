//
//  Int.swift
//  Putio
//
//  Created by Altay Aydemir on 10.11.2017.
//  Copyright © 2017 Put.io. All rights reserved.
//

import Foundation

extension Int64 {
    func bytesToHumanReadable() -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: self)
    }
}
