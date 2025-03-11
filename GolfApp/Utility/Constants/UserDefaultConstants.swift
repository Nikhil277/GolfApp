//
//  UserDefaultConstants.swift
//  GolfApp
//
//  Created by Nikhil B Kuriakose on 10/03/25.
//

import Foundation

struct UserDefaultKey {
    static let isLoggedIn = "isLoggedIn"
}

struct GetUserDefaults {
    static var isLoggedIn: Bool {
        return UserDefaults.standard.getBooleanValueFor(key: UserDefaultKey.isLoggedIn)
    }
}

struct SetUserDefaults {
    static func isLoggedIn(_ status: Bool) {
        UserDefaults.standard.setBooleanValueFor(key: UserDefaultKey.isLoggedIn, value: status)
    }
    
}
