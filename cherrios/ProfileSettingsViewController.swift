//
//  ProfileSettingsViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/1/20.
//

import UIKit

struct Ethnicity {
    let key: String
    let value: String
}

protocol ProfileSettingsDelegate {
    func didChooseValue(_: Any?) -> Void
}

let ageRange = Array(18...90)
let ethnicityRange = [
    Ethnicity(key: "asian", value: "Asian"),
    Ethnicity(key: "black", value: "Black"),
    Ethnicity(key: "latino", value: "Hispanic/Latino"),
    Ethnicity(key: "white", value: "White"),
    Ethnicity(key: "middle_eastern", value: "Middle Eastern"),
    Ethnicity(key: "multi_racial", value: "Multi-Racial"),
    Ethnicity(key: "native_american", value: "Native American"),
]

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
        
        if let option = option as? Ethnicity {
            return option.value
        }
        
        return nil
    }
}
