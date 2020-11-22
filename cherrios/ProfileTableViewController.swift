//
//  ProfileTableViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/31/20.
//

import UIKit
import Alamofire


struct Stat {
    var name: String
    var value: String
    var raw: Any?
}

struct Settings: Encodable {
    var dateOfBirth: String?
    var height: Int?
    var weight: Int?
    var ethnicity: String?
    var gender: String?
}

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileSettingsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stats: [Stat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stats = [
            Stat(name: "dateOfBirth", value: "Please select"),
            Stat(name: "height", value: "Please select"),
            Stat(name: "weight", value: "Please select"),
            Stat(name: "gender", value: "Please select"),
            Stat(name: "ethnicity", value: "Please select")
        ]
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
        cell.detailTextLabel?.text = stat.value

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let stat = stats[indexPath!.row]
        
        if segue.identifier == "showSettings" {
            let destination = segue.destination as! ProfileSettingsViewController
            destination.title = stat.name
            destination.delegate = self
        } else if segue.identifier == "showDateOfBirth" {
            let destination = segue.destination as! ProfileDateOfBirthViewController
            destination.title = stat.name
            destination.delegate = self
        }
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
        
        stats[row] = stat
        updateProfile()
    }
    
    func updateProfile() -> Void {
        var selectedValues: [String:Any] = [:]
        for stat in stats {
            if stat.name == "dateOfBirth" {
                selectedValues[stat.name] = stat.value
                continue
            }
            
            if stat.raw == nil {
                continue
            }
            
            selectedValues[stat.name] = stat.raw
        }
        
        let ethnicityType = selectedValues["ethnicity"] as? EthnicityType
        let genderType = selectedValues["gender"] as? GenderType
        let params = Settings(
            dateOfBirth: selectedValues["dateOfBirth"] as? String,
            height: selectedValues["height"] as? Int,
            weight: selectedValues["weight"] as? Int,
            ethnicity: ethnicityType?.rawValue,
            gender: genderType?.rawValue
        )
        print("params", params)
        
        let paramEncoder = URLEncodedFormParameterEncoder(
            encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase),
            destination: .httpBody
        )
        AF.request("http://localhost:3333/api/profiles/5c32533c-39f6-4b2f-aadd-ec242392b5d5",
           method: .post,
           parameters: params,
           encoder: paramEncoder,
           headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    print("Settings saved")
                case let .failure(error):
                    print(error)
                }
        }
    }
}
