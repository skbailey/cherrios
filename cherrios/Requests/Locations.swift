//
//  Locations.swift
//  cherrios
//
//  Created by Bailey on 5/9/21.
//

import Alamofire
import Foundation
import SwiftyJSON

struct LocationParams: Encodable {
    var latitude: String
    var longitude: String
    var profileID: String
}

class Locations {
    static func store(params: LocationParams, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        let paramEncoder = URLEncodedFormParameterEncoder(
            encoder: URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase),
            destination: .httpBody
        )
        
        AF.request(AppConfig.AppURL.locations,
                   method: .post,
                   parameters: params,
                   encoder: paramEncoder,
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
            }
    }
}
