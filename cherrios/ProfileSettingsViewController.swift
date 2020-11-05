//
//  ProfileSettingsViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/1/20.
//

import UIKit

enum Ethnicity: String, CaseIterable, ProfileSetting {
    case asian = "asian"
    case black = "black"
    case latino = "latino"
    case white = "white"
    case middleEastern = "middle_eastern"
    case multiRacial = "multi_racial"
    case nativeAmerican = "native_american"
    
    var formatted: String {
        switch self {
        case .asian:
            return "Asian"
        case .black:
            return "Black"
        case .latino:
            return "Hispanic/Latino"
        case .white:
            return "White"
        case .middleEastern:
            return "Middle Eastern"
        case .multiRacial:
            return "Multi-Racial"
        case .nativeAmerican:
            return "Native American"
        }
    }
}

enum Gender: String, CaseIterable, ProfileSetting {
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

protocol ProfileSetting {
    var formatted: String { get }
}

protocol ProfileSettingsDelegate {
    func didChooseValue(_: Any?) -> Void
}

let ageRange = Array(18...90)
let genderRange = Gender.allCases
let ethnicityRange = Ethnicity.allCases

class ProfileSettingsViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIPickerView!
    
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
        
        setOptions()
    }
    
    func setOptions() {
        switch title {
        case "age":
            profileSettingOptions = ageRange
        case "ethnicity":
            profileSettingOptions = ethnicityRange
        case "gender":
            profileSettingOptions = genderRange
        default:
            print("unexpected profile type")
        }
    }
    
    @objc func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func done() {
        let option = profileSettingOptions[picker.selectedRow(inComponent: 0)]
        delegate?.didChooseValue(option)
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        profileSettingOptions.count
    }
    
    // MARK: UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let option = profileSettingOptions[row]
        if let option = option as? Int {
            return String(option)
        }
        
        if let option = option as? ProfileSetting {
            return option.formatted
        }
        
        return nil
    }
}
