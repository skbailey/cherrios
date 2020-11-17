//
//  ProfileSettingsViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/1/20.
//

import UIKit

//enum Ethnicity: String, CaseIterable {
//    case asian = "asian"
//    case black = "black"
//    case latino = "latino"
//    case white = "white"
//    case middleEastern = "middle_eastern"
//    case multiRacial = "multi_racial"
//    case nativeAmerican = "native_american"
//
//    var formatted: String {
//        switch self {
//        case .asian:
//            return "Asian"
//        case .black:
//            return "Black"
//        case .latino:
//            return "Hispanic/Latino"
//        case .white:
//            return "White"
//        case .middleEastern:
//            return "Middle Eastern"
//        case .multiRacial:
//            return "Multi-Racial"
//        case .nativeAmerican:
//            return "Native American"
//        }
//    }
//}
//
//enum Gender: String, CaseIterable {
//    case male
//    case female
//
//    var formatted: String {
//        switch self {
//        case .male:
//            return "Male"
//        case .female:
//            return "Female"
//        }
//    }
//}

struct Weight: ProfileSetting {
    private static let metricToImperialCoeff: Float = 2.20462
    private static let imperialToMetricCoeff: Float = 0.453592
    private static let range: [Int] = Array(100...400)
    private static let formattedRange: [String] = range.map { String($0) }
    
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

//struct Height {
//    private var _imperial: Int
//    private var _metric: Int
//
//    var formatted: String {
//        let feet = _imperial / 12
//        let inches = _imperial % 12
//        return "\(String(feet))' \(inches)\""
//    }
//
//    init(imperial: Int) {
//        _imperial = imperial
//        let temp = Float(imperial) * 2.20462
//        _metric = Int(temp)
//    }
//}

protocol ProfileSetting {
    var formatted: String { get }
    var raw: Any? { get }
    var current: Int? { get set }
    
    func rangeOfValues() -> [String]
    func rangeOfRawValues() -> [Any]
}

protocol ProfileSettingsDelegate {
    func didChooseValue(_: ProfileSetting) -> Void
}

//let ageRange = Array(18...90)
//let heightRange = Array(48...84).map { Height(imperial: $0) }
//let genderRange = Gender.allCases
//let ethnicityRange = Ethnicity.allCases

class ProfileSettingsViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIPickerView!
    var settingOptions: [String:ProfileSetting] = [
//        "age":nil,
        "weight": Weight(imperial: 0),
//        "height":nil,
//        "gender":nil,
//        "ethnicity":nil
    ]
    
    var delegate: ProfileSettingsDelegate?
    var profileSettingOptions: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let standaloneItem = UINavigationItem()
        standaloneItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        standaloneItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        standaloneItem.title = title?.capitalized
        
        navigationBar.items = [standaloneItem]
        
        picker.dataSource = self
        picker.delegate = self
        
//        setOptions()
    }
    
//    func setOptions() {
//        switch title {
//        case "age":
//            profileSettingOptions = ageRange
//        case "weight":
//            profileSettingOptions = Weight.formattedRange
//        case "height":
//            profileSettingOptions = heightRange
//        case "ethnicity":
//            profileSettingOptions = ethnicityRange
//        case "gender":
//            profileSettingOptions = genderRange
//        default:
//            print("unexpected profile type")
//        }
//    }
    
    @objc func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func done() {        
        let row = picker.selectedRow(inComponent: 0)
        var setting = settingOptions[title!]
        let range = setting?.rangeOfRawValues() as! [Int]
        setting!.current = range[row]
        
        delegate?.didChooseValue(setting!)
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let setting = settingOptions[title!]
        let rangeOfValues = setting?.rangeOfValues()
        return rangeOfValues!.count
    }
    
    // MARK: UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let setting = settingOptions[title!]
        let rangeOfValues = setting?.rangeOfValues()
        let option = rangeOfValues![row]
        
        return option
    }
}
