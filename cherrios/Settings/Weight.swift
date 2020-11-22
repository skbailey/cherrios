//
//  Height.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

struct Weight: ProfileValue, ProfileSelection {
    private static let range: [Int] = Array(100...400)
    private static let formattedRange: [String] = range.map { "\(String($0)) lbs" }
    
    var selectedIndex: Int?
    
    var formatted: String {
        if let selectedIndex = selectedIndex {
            let selectedWeight = Weight.range[selectedIndex]
            return "\(String(selectedWeight)) lbs"
        }
        
        return ""
    }
    
    var raw: Any? {
        if let selectedIndex = selectedIndex {
            return Weight.range[selectedIndex]
        }
        
        return nil
    }
    
    func rangeOfValues() -> [String] {
        return Weight.formattedRange
    }
}
