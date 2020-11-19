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
    
    var selectedIndex: Int?
    
    var formatted: String {
        if let selectedIndex = selectedIndex {
            let selectedAge = Age.range[selectedIndex]
            return String(selectedAge)
        }
        
        return ""
    }
    
    var raw: Any? {
        if let selectedIndex = selectedIndex {
            return Age.range[selectedIndex]
        }
        
        return nil
    }
    
    func rangeOfValues() -> [String] {
        return Age.formattedRange
    }
}
