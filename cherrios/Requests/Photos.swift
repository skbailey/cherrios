//
//  Photos.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/10/21.
//

import Alamofire
import Foundation

class Photos {
    static func getAll(forProfile id: String, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        AF.request("http://localhost:3333/api/profiles/\(id)/photos",
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
            }
    }
}
