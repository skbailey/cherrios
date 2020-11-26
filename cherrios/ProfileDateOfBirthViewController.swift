//
//  ProfileDateOfBirthViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 11/22/20.
//

import UIKit

class ProfileDateOfBirthViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var picker: UIDatePicker!
    
    var delegate: ProfileSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let standaloneItem = UINavigationItem()
        standaloneItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        standaloneItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        standaloneItem.title = title?.capitalized
        
        navigationBar.items = [standaloneItem]
        
        picker.maximumDate = Date()
    }
    
    @objc func cancel() {
        dismiss(animated: false)
    }
    
    @objc func done() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        let selectedDate = dateFormatter.string(from: picker.date)
//        print(selectedDate)
        let dateOfBirth = DateOfBirth(current: picker.date)
        delegate?.didChooseValue(dateOfBirth)
        dismiss(animated: false)
    }
}
