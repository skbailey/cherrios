//
//  Photos.swift
//  cherrios
//
//  Created by Sherard Bailey on 1/10/21.
//

import Alamofire
import Foundation
import UIKit

class Photos {
    static func upload(photo: UIImage, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        guard let imgData = photo.jpegData(compressionQuality: 1) else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
        let imageName = UUID().uuidString
        AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData,
                                         withName: "photo",
                                         fileName: "\(imageName).jpeg",
                                         mimeType: "image/jpeg"
                )
            },
            to: String(format: AppConfig.AppURL.photos, profileID),
            method: .post,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            completion(response)
        }
    }
    
    static func getAll(forProfile id: String, completion: @escaping (_ res: AFDataResponse<Any>) -> Void) {
        let url = String(format: AppConfig.AppURL.photos, id)
        AF.request(url,
                   headers: ["Authorization": "Bearer \(authToken)"])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                debugPrint(response)
                completion(response)
            }
    }
}
