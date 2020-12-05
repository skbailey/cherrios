//
//  AppConfiguration.swift
//  cherrios
//
//  Created by Sherard Bailey on 12/4/20.
//

import Foundation

struct AppConfig {
    struct AppURL {
        static let login = "http://localhost:3333/api/auth/login"
        static let me = "http://localhost:3333/api/profiles/me"
        static let photos = "http://localhost:3333/api/profiles/%@/photos"
        static let profileIndex = "http://localhost:3333/api/profiles"
        static let profileDetail = "http://localhost:3333/api/profiles/%@"
    }
}
