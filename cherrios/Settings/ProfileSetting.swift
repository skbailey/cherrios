//
//  ProfileSetting.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/17/20.
//

import Foundation

protocol ProfileValue {
    var formatted: String { get }
    var raw: Any? { get }
}

protocol ProfileSelection {
    var selectedIndex: Int? { get set }
    func rangeOfValues() -> [String]
}

typealias ProfileSetting = ProfileValue & ProfileSelection
