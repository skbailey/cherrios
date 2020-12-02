//
//  ViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/20/20.
//

import Alamofire
import UIKit

struct Login: Encodable {
    let email: String
    let password: String
    let passwordConfirmation: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registerBtn(_ sender: UIButton) {
        guard let userEmail = email.text, userEmail != "" else {
            print("email address missing")
            return
        }
        
        guard let userPassword = password.text, userPassword != "" else {
            print("password missing")
            return
        }
        
        guard let userPasswordConfirmed = passwordConfirmation.text, userPasswordConfirmed != "" else {
            print("password confirmation missing")
            return
        }
        
        registerUser(email: userEmail, password: userPassword, passwordConfirm: userPasswordConfirmed)
    }
    
    func registerUser(email: String, password: String, passwordConfirm: String) {
        let loginParams = [
            "username": email,
            "password": password,
            "password_confirmation": passwordConfirm
        ]
        AF.request("http://localhost:3333/api/auth/register",
           method: .post,
           parameters: loginParams,
           encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { [weak self] response in
                debugPrint(response)
                switch response.result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case let .failure(error):
                    print(error)
                }
        }
    }
}
