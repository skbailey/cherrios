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
    let age: Int?
    let height: Int?
    let weight: Int?
}

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileSettingsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stats: [Stat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        stats = [
            Stat(name: "age", value: "Please select"),
            Stat(name: "height", value: "Please select"),
            Stat(name: "weight", value: "Please select"),
            Stat(name: "gender", value: "Please select"),
            Stat(name: "ethnicity", value: "Please select")
        ]

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            let indexPath = tableView.indexPathForSelectedRow
            let stat = stats[indexPath!.row]
            let destination = segue.destination as! ProfileSettingsViewController
            destination.title = stat.name
            destination.delegate = self
        }
    }
    
    // MARK: ProfileSettingsDelegate method
    
    func didChooseValue(_ option: ProfileSetting) {
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
            if stat.raw == nil {
                continue
            }
            
            selectedValues[stat.name] = stat.raw
        }
        
        let params = Settings(
            age: selectedValues["age"] as? Int,
            height: selectedValues["height"] as? Int,
            weight: selectedValues["weight"] as? Int
        )
        
        AF.request("http://localhost:3333/api/profiles/5c32533c-39f6-4b2f-aadd-ec242392b5d5",
                   
           method: .post,
           parameters: params,
           encoder: URLEncodedFormParameterEncoder(destination: .httpBody),
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
