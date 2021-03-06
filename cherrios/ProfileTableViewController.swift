//
//  ProfileTableViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/31/20.
//

import UIKit
import SwiftyJSON
import Alamofire


struct Stat {
    var name: String
    var value: String?
    var raw: Any?
}

struct Settings: Encodable {
    var dateOfBirth: String?
    var height: Int?
    var weight: Int?
    var ethnicity: String?
    var gender: String?
    var description: String?
}

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                                  ProfileSettingsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    private var imagePicker = UIImagePickerController()
    private let loader = ImageLoader()
    
    var stats: [Stat] = [
        Stat(name: "dateOfBirth"),
        Stat(name: "height"),
        Stat(name: "weight"),
        Stat(name: "gender"),
        Stat(name: "ethnicity")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileTableViewController.imageViewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        loadProfileImage()
        loadStats()
    }
    
    private func loadProfileImage() {
        Photos.getAll(forProfile: profileID) { [weak self] response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if !json.isEmpty {
                    let path = json[0]["path"]
                    if let imgPath = path.string {
                        let imgURL = "http://d241eitbp7g6mq.cloudfront.net/\(imgPath)"
                        let url = URL(string: imgURL)
                        _ = self?.loader.loadImage(url!) { [weak self] result in
                          do {
                            let image = try result.get()
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                          } catch {
                            print(error)
                          }
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func loadStats() {
        var savedStats: [Stat] = []
        
        for stat in stats {
            var newStat = Stat(name: stat.name)
            
            switch stat.name {
            case "dateOfBirth":
                if stat.raw != nil {
                    newStat.raw = stat.raw
                    newStat.value = stat.value
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    
                    if let value = UserDefaults.standard.string(forKey: stat.name) {
                        let date = dateFormatter.date(from: value)
                        let dateOfBirth = DateOfBirth(current: date)
                        
                        newStat.raw = dateOfBirth.raw
                        newStat.value = dateOfBirth.formatted
                    }
                }
            case "height":
                let value = UserDefaults.standard.integer(forKey: stat.name)
                if value != 0 {
                    let height = Height(value: value)
                    newStat.raw = height.selectedValue
                    newStat.value = height.formatted
                } else {
                    newStat.raw = stat.raw
                }
                
            case "weight":
                let value = UserDefaults.standard.integer(forKey: stat.name)
                if value != 0 {
                    let weight = Weight(value: value)
                    newStat.raw = weight.selectedValue
                    newStat.value = weight.formatted
                } else {
                    newStat.raw = stat.raw
                }
                
            case "ethnicity":
                if stat.raw != nil {
                    newStat.raw = stat.raw
                    newStat.value = stat.value
                } else {
                    let defaultValue = UserDefaults.standard.string(forKey: stat.name)
                    if let value = defaultValue {
                        let ethnicity = Ethnicity(value: value)
                        newStat.raw = ethnicity.raw
                        newStat.value = ethnicity.formatted
                    }
                }
            case "gender":
                if stat.raw != nil {
                    newStat.raw = stat.raw
                    newStat.value = stat.value
                } else {
                    let defaultValue = UserDefaults.standard.string(forKey: stat.name)
                    if let value = defaultValue {
                        let gender = Gender(value: value)
                        newStat.raw = gender.raw
                        newStat.value = gender.formatted
                    }
                }
            default:
                print("Unexpected profile setting")
            }
            
            savedStats.append(newStat)
        }
        
        stats = savedStats
        
        textView.text = UserDefaults.standard.string(forKey: "description")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            let indexPath = tableView.indexPathForSelectedRow
            let stat = stats[indexPath!.row]
            let destination = segue.destination as! ProfileSettingsViewController
            destination.title = stat.name
            destination.delegate = self
        } else if segue.identifier == "showDateOfBirth" {
            let indexPath = tableView.indexPathForSelectedRow
            let stat = stats[indexPath!.row]
            let destination = segue.destination as! ProfileDateOfBirthViewController
            destination.title = stat.name
            destination.delegate = self
        }
    }
    
    func uploadPhoto(_ photo: UIImage) -> Void {
        Photos.upload(photo: photo, isPrimary: true) { response in
            switch response.result {
                case .success:
                    print("successfully uploaded photo", response)
                case let .failure(error):
                    print("failed", error)
                    break
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath)
        
        let stat = stats[indexPath.row]
        cell.textLabel?.text = stat.name
        cell.detailTextLabel?.text = stat.value ?? "Please select"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stat = stats[indexPath.row]
        if stat.name == "dateOfBirth" {
            performSegue(withIdentifier: "showDateOfBirth", sender: nil)
        } else {
            performSegue(withIdentifier: "showSettings", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == stats.count - 1 {
            tableViewHeight.constant = tableView.contentSize.height
        }
    }
    
    // MARK: UIImagePickerControllerDelegate method

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }

        imageView.image = image
        
        uploadPhoto(image)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: ProfileSettingsDelegate method
    
    func didChooseValue(_ option: ProfileValue) {
        let indexPath = tableView.indexPathForSelectedRow
        
        let row = indexPath!.row
        let cell = tableView.cellForRow(at: indexPath!)
        cell?.detailTextLabel?.text = option.formatted
        
        var stat = stats[row]
        stat.value = option.formatted
        stat.raw = option.raw
        
        // store codable object instead in UserDefaults
        switch option.raw {
        case is Gender.GenderType:
            let genderValue = option.raw as! Gender.GenderType
            UserDefaults.standard.set(genderValue.rawValue, forKey: stat.name)
        case is Ethnicity.EthnicityType:
            let ethnicityValue = option.raw as! Ethnicity.EthnicityType
            UserDefaults.standard.set(ethnicityValue.rawValue, forKey: stat.name)
        default:
            UserDefaults.standard.set(stat.raw, forKey: stat.name)
        }
       
        
        stats[row] = stat
        updateProfile()
    }
    
    func updateProfile() -> Void {
        var selectedValues: [String:Any] = [:]
        for stat in stats {
            if stat.name == "dateOfBirth" {
                let dateFormatterPrint = ISO8601DateFormatter()
                dateFormatterPrint.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let dateString = dateFormatterPrint.string(from: stat.raw as! Date)
                
                selectedValues[stat.name] = dateString
                continue
            }
            
            if stat.raw == nil {
                continue
            }
            
            selectedValues[stat.name] = stat.raw
        }
        
        let ethnicityType = selectedValues["ethnicity"] as? Ethnicity.EthnicityType
        let genderType = selectedValues["gender"] as? Gender.GenderType
        let params = Settings(
            dateOfBirth: selectedValues["dateOfBirth"] as? String,
            height: selectedValues["height"] as? Int,
            weight: selectedValues["weight"] as? Int,
            ethnicity: ethnicityType?.rawValue,
            gender: genderType?.rawValue,
            description: textView.text
        )
        
        Profiles.update(id: profileID, params: params) { response in
            switch response.result {
            case .success:
                print("Settings saved")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // MARK - Tap Gesture
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ProfileTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text!)
        updateProfile()
        UserDefaults.standard.set(textView.text!, forKey: "description")
    }
}
