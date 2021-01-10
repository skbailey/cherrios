//
//  Profiles.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/10/21.
//

import Alamofire
import Foundation
import SwiftyJSON

class Profiles {
    static func getIndex(completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        AF.request(AppConfig.AppURL.profileIndex,
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
            }
    }
    
    static func me(completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        AF.request(AppConfig.AppURL.me,
                   method: .get,
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
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
}
