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
        guard let userEmail = emailTextField.text, userEmail != "" else {
            print("email address missing")
            return
        }
        
        guard let userPassword = passwordTextField.text, userPassword != "" else {
            print("password missing")
            return
        }
        
        Authentication.login(email: userEmail, password: userPassword) { [weak self] response in
            debugPrint(response)
            
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if let token = json["token"].string {
                    authToken = token
                    self?.performSegue(withIdentifier: "LoginUser", sender: nil)
                }

            case let .failure(error):
                print(error)
            }
        }
    }
}
