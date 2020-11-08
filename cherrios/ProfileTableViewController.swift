//
//  ProfileTableViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/31/20.
//

struct Stat {
    var name: String
    var value: String
}

import UIKit

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileSettingsDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var stats: [Stat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        stats = [
            Stat(name: "age", value: "27"),
            Stat(name: "height", value: "5' 9\""),
            Stat(name: "weight", value: "134 lbs"),
            Stat(name: "gender", value: "male"),
            Stat(name: "ethnicity", value: "asian")
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
    
    func didChooseValue(_ option: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        
        if let option = option as? Int {
            cell?.detailTextLabel?.text = String(option)
        }
        
        if let option = option as? ProfileSetting {
            cell?.detailTextLabel?.text = option.formatted
        }
    }
}
