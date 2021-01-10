//
//  Profiles.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/10/21.
//

import Alamofire
import Foundation

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
}
