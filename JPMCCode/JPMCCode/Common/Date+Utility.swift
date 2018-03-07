//
//  Date+Utility.swift
//  JPMCCode
//
//  Created by Rajdeep Arora on 3/7/18.
//  Copyright © 2018 Rajdeep Arora. All rights reserved.
//

import Foundation
public extension Double {
    func getTheDateFromTime(timestamp: Double) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd MMM, yyyy hh:mm aa"
        let value = timestamp / 1000
        let date = NSDate(timeIntervalSince1970: TimeInterval(value))
        return dateformat.string(from: date as Date)
    }
}
