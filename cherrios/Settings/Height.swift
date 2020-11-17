//
//  Height.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

struct Height: ProfileSetting {
    private static let imperialToMetricCoeff: Float = 2.54 // inches to cm
    private static let metricToImperialCoeff: Float = 0.393701 // cm to inches
    private static let range: [Int] = Array(48...84)
    private static let formattedRange: [String] = range.map {
        let feet = $0 / 12
        let inches = $0 % 12
        return "\(String(feet))' \(inches)\""
    }
    
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
            let temp = Float(newValue) * Height.imperialToMetricCoeff
            _metric = Int(temp)
            _imperial = newValue
        }
    }
    
    var metric: Int {
        get {
            return _metric
        }
        
        set(newValue) {
            let temp = Float(newValue) * Height.metricToImperialCoeff
            _imperial = Int(temp)
            _metric = newValue
        }
    }

    var formatted: String {
        let feet = _imperial / 12
        let inches = _imperial % 12
        return "\(String(feet))' \(inches)\""
    }
    
    var raw: Any? {
        return _imperial
    }

    init(imperial: Int) {
        _imperial = imperial
        let temp = Float(imperial) * 2.20462
        _metric = Int(temp)
    }
    
    func rangeOfValues() -> [String] {
        return Height.formattedRange
    }
    
    func rangeOfRawValues() -> [Any] {
        return Height.range
    }
}
