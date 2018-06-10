//
//  User.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class UserModel {
    var userId: String?
    var email: String?
    var name: String?
    var number: String?
    var profileImageUrl: String?
}

extension UserModel {
    static func transformUser(dict: [String: Any], key: String) -> UserModel {
        let user = UserModel()
        user.userId = key
        user.email = dict["email"] as? String
        user.name = dict["name"] as? String
        user.number = dict["number"] as? String
        user.profileImageUrl = dict["profilePictureUrl"] as? String
        return user
    }
}
