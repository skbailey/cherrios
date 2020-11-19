//
//  ProfileSettingsViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/1/20.
//

import UIKit

protocol ProfileSettingsDelegate {
    func didChooseValue(_: ProfileSetting) -> Void
}

class ProfileSettingsViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIPickerView!
    var settingOptions: [String:ProfileSetting] = [
        "age": Age(),
        "weight": Weight(),
        "height": Height(),
        "gender": Gender(),
        "ethnicity":Ethnicity()
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
    }
    
    @objc func cancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func done() {        
        let row = picker.selectedRow(inComponent: 0)
        var setting = settingOptions[title!]
        setting!.selectedIndex = row
        
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
