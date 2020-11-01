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

class ProfileTableViewController: UITableViewController, ProfileSettingsDelegate {
    
    var stats: [Stat] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        stats = [
            Stat(name: "age", value: "18 - 90"),
            Stat(name: "weight", value: "134 lb"),
            Stat(name: "ethnicity", value: "asian"),
            Stat(name: "gender", value: "male"),
            Stat(name: "height", value: "5' 9")
        ]

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath)
        
        let stat = stats[indexPath.row]
        cell.textLabel?.text = stat.name
        cell.detailTextLabel?.text = stat.value

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings" {
            let destination = segue.destination as! ProfileSettingsViewController
            destination.delegate = self
            let indexPath = tableView.indexPathForSelectedRow
            let stat = stats[indexPath!.row]
            destination.title = stat.name
        }
    }
    
    // MARK: ProfileSettingsDelegate method
    
    func didChooseSetting(_ value: String) {
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: indexPath!)
        cell?.detailTextLabel?.text = value
    }
    
}
