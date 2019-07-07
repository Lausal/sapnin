//
//  UserApi.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import ProgressHUD
import FirebaseStorage

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
    
    func observeCurrentUser(onSuccess: @escaping (UserModel) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        DB_REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                onSuccess(user)
            }
        })
    }
    
    func observeUser(userId: String, onSuccess: @escaping (UserModel) -> Void) {
        DB_REF_USERS.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                onSuccess(user)
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
    func checkIfContactExists(number: String, contactExists: @escaping (Bool, String?) -> ()) {
        let query = DB_REF_USERS.queryOrdered(byChild: "number").queryEqual(toValue: number)

        query.observe(.value) { (snapshot) in
            if snapshot.exists() {
                
                snapshot.children.forEach({ (s) in
                    let child = s as! DataSnapshot
                    if let dict = child.value as? [String: Any] {
                        let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                        contactExists(true, child.key)
                    }
                })
                
            } else {
                contactExists(false, nil)
            }
        }
    }
    
    ////////
    
    // Returns the current user ID
    var currentUserId: String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        } else {
            return ""
        }
    }
    
    // Create user in authentication section of Firebase. Once complete, use the returned reference from the authentication section to store in the User Database table
    func signUp(name: String, email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create user in authentication
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            // After successfully creating in Authentication, then create reference in database table
            if let authData = authDataResult {
                
                let dict: Dictionary <String,Any> = [
                    "uid": authData.uid, // This is the ID from authentication created
                    "email": authData.email,
                    "name": name
                ]
                
                Ref().databaseSpecificUserRef(uid: authData.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        onSuccess()
                    } else {
                        onError(error!.localizedDescription)
                    }
                })
                
            }
        }
    }
    
    // Function to sign user in whilst checking with Firebase authentication credentials
    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    // Function to reset password and send user an email to reset
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
}
