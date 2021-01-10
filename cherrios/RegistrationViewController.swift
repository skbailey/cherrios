//
//  ViewController.swift
//  cherrios
//
//  Created by Sherard Bailey on 10/20/20.
//

import Alamofire
import UIKit

class RegistrationViewController: UIViewController {
    
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
        
        registerUser(email: userEmail, password: userPassword, passwordConfirmation: userPasswordConfirmed)
    }
    
    func registerUser(email: String, password: String, passwordConfirmation: String) {
        Registration.signup(
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation) { [weak self] response in
                switch response.result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case let .failure(error):
                    print(error)
                }
            }
    }
}
