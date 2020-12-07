//
//  Gender.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/18/20.
//

import Foundation

struct Gender: ProfileValue, ProfileSelection {
    enum GenderType: String, CaseIterable {
        case male
        case female

        var formatted: String {
            switch self {
            case .male:
                return "Male"
            case .female:
                return "Female"
            }
        }
    }
    
    var selectedIndex: Int?

    var formatted: String {
        if let selectedIndex = selectedIndex {
            let kind = GenderType.allCases[selectedIndex]
            return kind.formatted
        }
        
        return ""
    }
    
    var raw: Any? {
        if let selectedIndex = selectedIndex {
            return GenderType.allCases[selectedIndex]
        }
        
        return nil
    }
    
    func rangeOfValues() -> [String] {
        GenderType.allCases.map { kind in
            kind.formatted
        }
    }
}
