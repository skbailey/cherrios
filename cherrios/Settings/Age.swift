//
//  Age.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

struct Age: ProfileSetting {
    private static let range: [Int] = Array(18...90)
    private static let formattedRange: [String] = range.map { String($0) }
    
    var formatted: String {
        if let current = current {
            return String(current)
        }
        
        return ""
    }
    
    var raw: Any? {
        return current
    }
    
    var current: Int?
    
    func rangeOfValues() -> [String] {
        return Age.formattedRange
    }
    
    func rangeOfRawValues() -> [Any] {
        return Age.range
    }
}
