//
//  AuthService.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    static func logout(onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let logoutError {
            onError(logoutError.localizedDescription)
            return
        }
    }
    
    static func updateUserInformation(imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let userId = Api.User.currentUserId
        
        // Store the new profile image into Firebase storage
        let storageRef = Storage.storage().reference().child("profilePictures").child(userId)
        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                return
            } else {
                // After saving into Firebase storage, retrieve the new URL and store into the corresponding Firebase database table
                //let profileImageUrl = metadata?.downloadURL()?.absoluteString
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        
                    } else {
                        let dict = ["profilePictureUrl": url?.absoluteString]
                        
                        Api.User.DB_REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                onError(error!.localizedDescription)
                            } else {
                                onSuccess()
                            }
                        })
                    }
                })
                
            }
        })
    }
    
    static func updateUserMobileNumber(number: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        let dict = ["number": number]
        Api.User.DB_REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error != nil {
                onError(error!.localizedDescription)
            } else {
                onSuccess()
            }
        })
        
    }
    
}
