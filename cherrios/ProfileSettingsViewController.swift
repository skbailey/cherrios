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

protocol ProfileSettingsDelegate {
    func didChooseValue(_: ProfileSetting) -> Void
}

//let genderRange = Gender.allCases
//let ethnicityRange = Ethnicity.allCases

class ProfileSettingsViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIPickerView!
    var settingOptions: [String:ProfileSetting] = [
        "age":Age(),
        "weight": Weight(imperial: 0),
        "height": Height(imperial: 0),
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
