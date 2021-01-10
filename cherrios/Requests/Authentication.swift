//
//  Login.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/9/21.
//

import Alamofire
import Foundation
import SwiftyJSON

class Authentication {
    static func login(email: String, password: String, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        let loginParams = ["username": email, "password": password]
        AF.request(AppConfig.AppURL.login,
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
