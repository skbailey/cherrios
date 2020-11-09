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
        
        // Do any additional setup after loading the view.
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
        
        let loginParams = ["username": userEmail, "password": userPassword]
        AF.request("http://localhost:3333/api/auth/login",
                   method: .post,
                   parameters: loginParams,
                   encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { [weak self] response in
                debugPrint(response)
                switch response.result {
                case let .success(value):
                    print("Login Successful")
                    let json = JSON(value)
                    if let token = json["token"].string {
                        print("Token", token)
                        AF.request("http://localhost:3333/api/profiles",
                                   headers: ["Authorization": "Bearer \(token)"])
                            .validate(statusCode: 200..<300)
                            .validate(contentType: ["text/plain"])
                            .responseString { response in
                                debugPrint(response)
                                
                                switch response.result {
                                case .success:
                                    print("Successfully fetched profiles/used JWT")
                                case let .failure(error):
                                    print(error)
                                }
                            }
                    }
                    
                    self?.performSegue(withIdentifier: "LoginUser", sender: nil)
                case let .failure(error):
                    print(error)
                }
            }
    }
}
