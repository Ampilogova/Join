//
//  DateFormatter.swift
//  Join
//
//  Created by Tatiana Ampilogova on 11/2/20.
//

import Foundation

public extension Date {
    func formatedTime() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.string(from: self)
            let dateString = dateFormatter.string(from: self)
            return dateString
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.string(from: self)
            let dateString = dateFormatter.string(from: self)
            return dateString
        }
    }
}
