//
//  PostApi.swift
//  Sapnin
//
//  Created by Alan Lau on 20/07/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import FirebaseStorage

class Post {
    
    var DB_REF_POSTS = Database.database().reference().child("posts")
    
    func addPost(channelId: String, imageData: Data, onSuccess: @escaping () -> Void) {
        uploadImageToFirebaseStorage(channelId: channelId, imageData: imageData) { (photoUrl) in
            self.sendDatatoPostDB(channelId: channelId, photoUrl: photoUrl, onSuccess: onSuccess)
        }
    }
    
    func uploadImageToFirebaseStorage(channelId: String, imageData: Data, onSuccess: @escaping (_ photoUrl: String) -> Void) {
        // Store the photo image in Firebase storage with a unique generated ID
        let imageIDString = NSUUID().uuidString // Create a unique ID
        let storageRef = Storage.storage().reference().child("channelPhotos").child(channelId).child(imageIDString)
        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            }
            // photoURL is URL of storage location
            if let photoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }
        })
    }
    
    func sendDatatoPostDB(channelId: String, photoUrl: String, onSuccess: @escaping () -> Void) {
        let newPostId = DB_REF_POSTS.childByAutoId().key
        let newPostReference = DB_REF_POSTS.child(newPostId)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let dict = ["uid": Api.User.currentUserId, "photoUrl": photoUrl, "timestamp": timestamp] as [String : Any]
        
        newPostReference.setValue(dict) { (error, ref) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            } else {
                let channelPostRef = Api.channelPost.DB_REF_CHANNEL_POSTS.child(channelId).child(newPostId)
                channelPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        return
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        onSuccess()
                    }
                })
            }
        }
    }
    
    
}
