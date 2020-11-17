//
//  Height.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

struct Weight: ProfileSetting {
    private static let metricToImperialCoeff: Float = 2.20462 // kg to lbs
    private static let imperialToMetricCoeff: Float = 0.453592 // lbs to kg
    private static let range: [Int] = Array(100...400)
    private static let formattedRange: [String] = range.map { "\(String($0)) lbs" }
    
    private var _imperial: Int = 0
    private var _metric: Int = 0
    
    var current: Int? {
        didSet {
            imperial = current!
        }
    }
    
    var imperial: Int {
        get {
            return _imperial
        }
        
        set(newValue) {
            let temp = Float(newValue) * Weight.imperialToMetricCoeff
            _metric = Int(temp)
            _imperial = newValue
        }
    }
    
    var metric: Int {
        get {
            return _metric
        }
        
        set(newValue) {
            let temp = Float(newValue) * Weight.metricToImperialCoeff
            _imperial = Int(temp)
            _metric = newValue
        }
    }
    
    var formatted: String {
        return "\(String(_imperial)) lbs"
    }
    
    var raw: Any? {
        return _imperial
    }
    
    init(imperial: Int) {
        self.imperial = imperial
    }
    
    func rangeOfValues() -> [String] {
        return Weight.formattedRange
    }
    
    func rangeOfRawValues() -> [Any] {
        return Weight.range
    }
}
