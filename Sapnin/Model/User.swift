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
    var profilePictureUrl: String?
    
    init(userId: String, email: String, name: String) {
        self.userId = userId
        self.email = email
        self.name = name
    }
    
    // Read the User JSON/dict output from database and then assign to local variables for us to utilise
    static func transformUser(dict: [String: Any]) -> User? {

        // Read the JSON and assign to local variable - these are the mandatory fields
        guard let userId = dict["uid"] as? String,
            let email = dict["email"] as? String,
            let name = dict["name"] as? String else {
                return nil
        }
        
        // Now create a user instance
        let user = User(userId: userId, email: email, name: name)
        
        // If user profile URL exists, then also add this attribute to the user object created above
        if let profilePictureUrl = dict["profilePictureUrl"] as? String {
            user.profilePictureUrl = profilePictureUrl
        }
        
        return user
    }
    
}
