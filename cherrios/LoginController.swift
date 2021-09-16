//
//  LoginController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/21/20.
//

import Alamofire
import SwiftyJSON
import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToLogin( _ seg: UIStoryboardSegue) {
        
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        guard let email = emailTextField?
                .text?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased(),
              email != "" else {
            print("email address missing")
            return
        }
        
        guard let password = passwordTextField?
                .text?
                .trimmingCharacters(in: .whitespacesAndNewlines),
              password != "" else {
            print("password missing")
            return
        }
        
        Authentication.login(email: email, password: password) { [weak self] response in
            // debugPrint(response)
            
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                
                if let token = json["token"].string,
                   let id = json["id"].string {
                    authToken = token
                    profileID = id
                    
                    self?.performSegue(withIdentifier: "LoginUser", sender: nil)
                } else {
                    print("warning: invalid token or id")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
