//
//  ProfileSetting.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

protocol ProfileSetting {
    var formatted: String { get }
    var raw: Any? { get }
    var current: Int? { get set }
    
    func rangeOfValues() -> [String]
    func rangeOfRawValues() -> [Any]
}
