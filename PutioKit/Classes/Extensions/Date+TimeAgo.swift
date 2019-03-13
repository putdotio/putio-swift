//
//  Date+TimeAgo.swift
//  Putio
//
//  Created by Altay Aydemir on 23.01.2018.
//  Copyright © 2018 Put.io. All rights reserved.
//

import Foundation

extension Date {
    // swiftlint:disable:next cyclomatic_complexity
    func timeAgoSinceDate() -> String {
        let date = self
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        if components.year! >= 2 {
            return "\(components.year!) years ago"
        }

        if components.year! >= 1 {
            return "last year"
        }

        if components.month! >= 2 {
            return "\(components.month!) months ago"
        }

        if components.month! >= 1 {
            return "last month"
        }

        if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        }

        if components.weekOfYear! >= 1 {
            return "last week"
        }

        if components.day! >= 2 {
            return "\(components.day!) days ago"
        }

        if components.day! >= 1 {
            return "yesterday"
        }

        if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        }

        if components.hour! >= 1 {
            return "an hour ago"
        }

        if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        }

        if components.minute! >= 1 {
            return "a minute ago"
        }

        if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        }

        return "just now"
    }
}
