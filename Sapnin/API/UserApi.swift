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

// Typealias is similar to a variable, but is used to reference closure arguments. In this case the onSuccess will return a User object
typealias UserCompletion = (User) -> Void

class UserApi {
    
    var DB_REF_USERS = Database.database().reference().child("users")
    
    var DB_REF_CURRENT_USER: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }

        return DB_REF_USERS.child(currentUser.uid)
    }
    
//    var CURRENT_USER: User? {
//        if let currentUser = Auth.auth().currentUser {
//            return currentUser
//        } else {
//            return nil
//        }
//    }
    
//    func observeCurrentUser(onSuccess: @escaping (User) -> Void) {
//        guard let currentUser = Auth.auth().currentUser else {
//            return
//        }
//
//        DB_REF_USERS.child(currentUser.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                let user = User.transformUser(dict: dict, key: snapshot.key)
//                //onSuccess(user)
//            }
//        })
//    }
    
//    func observeUser(userId: String, onSuccess: @escaping (User) -> Void) {
//        DB_REF_USERS.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                let user = User.transformUser(dict: dict, key: snapshot.key)
//                onSuccess(user!)
//            }
//        })
//    }
    
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
    
//    // Checks if the number input exists in the "number" attribute
//    func checkIfContactExists(number: String, contactExists: @escaping (Bool, String?) -> ()) {
//        let query = DB_REF_USERS.queryOrdered(byChild: "number").queryEqual(toValue: number)
//
//        query.observe(.value) { (snapshot) in
//            if snapshot.exists() {
//                
//                snapshot.children.forEach({ (s) in
//                    let child = s as! DataSnapshot
//                    if let dict = child.value as? [String: Any] {
//                        let user = User.transformUser(dict: dict, key: snapshot.key)
//                        contactExists(true, child.key)
//                    }
//                })
//                
//            } else {
//                contactExists(false, nil)
//            }
//        }
//    }
    
    ////////
    
    // Returns the current user ID
    var currentUserId: String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        } else {
            return ""
        }
    }
    
    // Update Phone Number of User //When coming from Facebook
    func updatePhonenNumberUserById(uid: String,phoneNumber:String) {
        DB_REF_USERS.child(uid).updateChildValues(["phoneNumber":phoneNumber])
    }
    
    // Get signle user information
    func observeUsers(onSuccess: @escaping (UserCompletion)) {
        DB_REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    // Get user information for a specific user based on user ID
    func observeSpecificUserById(uid: String, onSuccess: @escaping (UserCompletion)) {
        DB_REF_USERS.child(uid).observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    //Check if user exists with phone number
    func checkUserExistense(phoneNumber: String, onSuccess: @escaping (User?) -> ()){
//        var p = phoneNumber
        DB_REF_USERS.queryOrdered(byChild: "phoneNumber").queryEqual(toValue: phoneNumber)
            .observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let u = snapshot.value as? [String: Any]{
                        onSuccess(User.transformUser(dict: u[u.keys.first!] as! [String : Any]))
                    }else{
                        onSuccess(nil)
                    }
                } else {
                    onSuccess(nil)
                }
        })
    }
    
    // Create user in authentication section of Firebase. Once complete, use the returned reference from the authentication section to store in the User Database table
    func signUp(name: String, email: String, phoneNumber:String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create user in authentication
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            // After successfully creating in Authentication, then create reference in database table
            if let authData = authDataResult {
                
                let dict: Dictionary <String,Any> = [
                    "uid": authData.user.uid, // This is the ID from authentication created
                    "email": authData.user.email,
                    "name": name,
                    "phoneNumber" : phoneNumber
                ]
                
                Ref().databaseSpecificUserRef(uid: authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
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
