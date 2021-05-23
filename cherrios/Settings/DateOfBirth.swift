//
//  DateOfBirth.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/19/20.
//

import Foundation

struct DateOfBirth: ProfileValue {
    var current: Date?
    var dateFormatter = DateFormatter()
    
    init(current: Date?) {
        self.current = current
        dateFormatter.dateFormat = "dd MMMM yyyy"
    }
    
    var formatted: String {
        if let current = current {
            let selectedDate = dateFormatter.string(from: current)
            return selectedDate
        }
        
        return ""
    }
    
    var raw: Any? {
        return current
    }
}
