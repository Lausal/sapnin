//
//  UserApi.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var DB_REF_USERS = Database.database().reference().child("users")
    
    var DB_REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return DB_REF_USERS.child(currentUser.uid)
    }
    
    var CURRENT_USER: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        } else {
            return nil
        }
    }
    
    func observeCurrentUser(completion: @escaping (UserModel) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        DB_REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func checkIfUserExists(userId: String, userExists: @escaping (Bool) -> ()) {
        DB_REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(userId) {
                print("User exists")
                userExists(true)
            } else {
                print("New user")
                userExists(false)
            }
        }
    }
    
    // Checks if the number input exists in the "number" attribute
    func checkIfContactExists(number: String, contactExists: @escaping (Bool) -> ()) {
        let query = DB_REF_USERS.queryOrdered(byChild: "number").queryEqual(toValue: number)
        query.observe(.value) { (snapshot) in
            if snapshot.exists() {
                print("EXISTS")
                //print("KEY: \(snapshot.key)")
                contactExists(true)
            } else {
                contactExists(false)
            }
        }
    }
    
}
