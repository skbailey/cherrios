//
//  FeedCollectionViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 12/19/20.
//

import Alamofire
import SwiftyJSON
import UIKit

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profiles: [URL] = []
    var loader = ImageLoader()
    private let itemsPerRow: CGFloat = 3
    private let reuseIdentifier = "FeedCell"
    private let sectionInsets = UIEdgeInsets(top: 5.0,
                                             left: 5.0,
                                             bottom: 5.0,
                                             right: 5.0)

    override func viewDidLoad() {
        super.viewDidLoad()

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

        // Do any additional setup after loading the view.
        loadUserProfile()
    }
    
    func loadUserProfile() -> Void {
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
                    let json = JSON(value)
                    if let id = json["id"].string {
                        profileID = id
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select the view")
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
