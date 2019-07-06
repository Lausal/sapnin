//
//  Ref.swift
//  Sapnin
//
//  Created by Alan Lau on 25/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import Firebase

let ROBOTO_REGULAR = "Roboto-Regular"
let ROBOTO_BOLD = "Roboto-Bold"

let REF_USER_TABLE = "users"

let IDENTIFIER_CHANNEL = "ChannelViewController"
let IDENTIFIER_LOGIN = "WelcomeViewController"
let IDENTIFER_CHANNEL_NAV_CONTROLLER = "ChannelNavigationController"
let IDENTIFER_LOGIN_NAV_CONTROLLER = "LoginNavigationController"

class Ref {
    
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    // Database user table reference
    var databaseUserTableRef: DatabaseReference {
        return databaseRoot.child(REF_USER_TABLE)
    }
    
    // Database specific user reference
    func databaseSpecificUserRef(uid: String) -> DatabaseReference {
        return databaseUserTableRef.child(uid)
    }
    
}
