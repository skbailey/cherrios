//
//  Registration.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/10/21.
//

import Alamofire
import Foundation

class Registration {
    static func signup(email: String, password: String, passwordConfirmation: String, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        let loginParams = [
            "email": email,
            "password": password,
            "password_confirmation": passwordConfirmation
        ]
        
        AF.request(AppConfig.AppURL.signup,
           method: .post,
           parameters: loginParams,
           encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
            }
    }
}
