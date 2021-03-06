//
//  FeedCollectionViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 12/19/20.
//

import Alamofire
import CoreLocation
import SwiftyJSON
import UIKit

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profiles: [URL] = []
    var loader = ImageLoader()
    private let itemsPerRow: CGFloat = 3
    private let reuseIdentifier = "FeedCell"
    private let sectionInsets = UIEdgeInsets(top: 1.0,
                                             left: 1.0,
                                             bottom: 1.0,
                                             right: 1.0)
    
    override func viewWillAppear(_ animated: Bool) {
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
        profiles.append(profile1!)
        profiles.append(profile2!)
        profiles.append(profile3!)
        profiles.append(profile4!)
        profiles.append(profile1!)
        profiles.append(profile2!)
        profiles.append(profile3!)
        profiles.append(profile4!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Notification Center
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateLocation),
            name: NSNotification.Name(rawValue: "locationUpdate"),
            object: nil
        )
        
        // Setup Core Location
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
        
        loadUserProfile()
    }
    
    @objc func updateLocation(notification: NSNotification) {
        print("Location received")
        
        if let data = notification.userInfo as? [String: [CLLocation]],
           let locations = data["locations"],
           locations.count > 0 {
            let currentLocation = locations.last!
            
            print("let look at the notification, there are updates", currentLocation)
            let params = LocationParams(
                latitude: "\(currentLocation.coordinate.latitude)",
                longitude: "\(currentLocation.coordinate.longitude)",
                profileID: profileID
            )
            
            Locations.store(params: params) { response in
                switch response.result {
                case let .success(value):
                    let json = JSON(value)
                    print("stored location data", json)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    func loadUserProfile() -> Void {
        Profiles.me { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if let id = json["id"].string {
                    profileID = id
                    
                    Profiles.getIndex(forProfile: profileID) { profileResponse in
                        switch profileResponse.result {
                        case let .success(value):
                            print("Got profile index", value)
                        case let .failure(error):
                            print("Failed to retrieve profile index", error)
                        }
                    }
                }
                
                UserDefaults.standard.setValue(json["date_of_birth"].string, forKey: "dateOfBirth")
                UserDefaults.standard.setValue(json["gender"].string, forKey: "gender")
                UserDefaults.standard.setValue(json["ethnicity"].string, forKey: "ethnicity")
                UserDefaults.standard.setValue(json["height"].int, forKey: "height")
                UserDefaults.standard.setValue(json["weight"].int, forKey: "weight")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @IBAction func viewProfile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "viewProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileDetail" {
            if let viewController = segue.destination as? ProfileDetailViewController {
                if let indexPaths = collectionView.indexPathsForSelectedItems,
                   indexPaths.count == 1 {
                    let path = indexPaths.first!
                    viewController.imageURL = profiles[path.item]
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileDetail", sender: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
    
        // Configure the cell
        let imageUrl = profiles[indexPath.row]
        let token = loader.loadImage(imageUrl) { result in
          do {
            let image = try result.get()
            DispatchQueue.main.async {
              cell.profileImageView.image = image
            }
          } catch {
            print(error)
          }
        }

        cell.onReuse = {
          if let token = token {
            self.loader.cancelLoad(token)
          }
        }
    
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
