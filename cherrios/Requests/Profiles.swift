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
    static func update(id: String, params: Settings, completion: @escaping (_ res: AFDataResponse<Data?>) -> Void) {
        let paramEncoder = URLEncodedFormParameterEncoder(
            encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase),
            destination: .httpBody
        )
        
        AF.request(String(format: AppConfig.AppURL.profileDetail, id),
           method: .post,
           parameters: params,
           encoder: paramEncoder,
           headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                debugPrint(response)
                completion(response)
            }
    }
    
    static func getIndex(forProfile currentProfile: String, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
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
            }
    }
}
