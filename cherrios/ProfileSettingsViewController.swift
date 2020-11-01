//
//  ProfileSettingsViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/1/20.
//

import UIKit

protocol ProfileSettingsDelegate {
    func didChooseSetting(_: String) -> Void
}

class ProfileSettingsViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIPickerView!
    
    let ageRange = Array(18...90)
    var delegate: ProfileSettingsDelegate? = nil
    
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
        let minAge = ageRange[picker.selectedRow(inComponent: 0)]
        let maxAge = ageRange[picker.selectedRow(inComponent: 1)]
        print("Age range", minAge, maxAge)
        let selection = String(format: "%d - %d", minAge, maxAge)
        delegate?.didChooseSetting(selection)
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ageRange.count
    }
    
    // MARK: UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let age = ageRange[row]
        return String(age)
    }
}