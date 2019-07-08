//
//  User.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class User {
    var userId: String?
    var email: String?
    var name: String?
    var number: String?
    var profileImageUrl: String?
}

extension User {
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.userId = key
        user.email = dict["email"] as? String
        user.name = dict["name"] as? String
        user.number = dict["number"] as? String
        user.profileImageUrl = dict["profilePictureUrl"] as? String
        return user
    }
}
