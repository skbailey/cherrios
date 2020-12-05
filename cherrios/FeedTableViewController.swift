//
//  FeedTableViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/27/20.
//

import Alamofire
import SwiftyJSON
import UIKit

struct Profile {
    var screenName: String!
    var age: Int!
    var description: String?
}

class FeedTableViewController: UITableViewController {
    
    var profiles: [URL] = []
    var loader = ImageLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let profile1 = URL(string: "https://s3.amazonaws.com/com.sherardbailey.tacos/smiling-dude.png")
        let profile2 = URL(string: "https://s3.amazonaws.com/com.sherardbailey.tacos/smiling-guy.jpg")
        let profile3 = URL(string: "https://s3.amazonaws.com/com.sherardbailey.tacos/smiling-older-man.png")
        let profile4 = URL(string: "https://s3.amazonaws.com/com.sherardbailey.tacos/smiling-woman.jpg")
        profiles.append(profile1!)
        profiles.append(profile2!)
        profiles.append(profile3!)
        profiles.append(profile4!)
        profiles.append(profile1!)
        profiles.append(profile2!)
        profiles.append(profile3!)
        profiles.append(profile4!)

        // Load current user profile
        print("Fetching logged in user profile")
        AF.request(AppConfig.AppURL.me,
                   method: .get,
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case let .success(value):
                    print("Login Successful")
                    let json = JSON(value)
                    if let id = json["id"].string {
                        profileID = id
                    }
                    
                case let .failure(error):
                    print(error)
                }
            }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profiles.count
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellIdentifier", for: indexPath) as! FeedTableViewCell

        let imageUrl = profiles[indexPath.row]
//        var content = cell.defaultContentConfiguration()
//        content.text = selectedProfile.screenName
//        cell.contentConfiguration = content
//        cell.textLabel?.text = selectedProfile.screenName
        // 1
        let token = loader.loadImage(imageUrl) { result in
          do {
            // 2
            let image = try result.get()
            // 3
            DispatchQueue.main.async {
              cell.profileImageView.image = image
            }
          } catch {
            // 4
            print(error)
          }
        }

        // 5
        cell.onReuse = {
          if let token = token {
            self.loader.cancelLoad(token)
          }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
