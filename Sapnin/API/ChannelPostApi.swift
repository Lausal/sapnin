//
//  ChannelPostApi.swift
//  Sapnin
//
//  Created by Alan Lau on 20/07/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class ChannelPostApi {
    
    // Function to submit a new post in a channel and set it in Firebase
    func submitChannelPost(channelId: String, image: UIImage, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create unique postId
        let postId = Ref().databaseChannelPostTableRef.childByAutoId().key
        
        // Save photo into storage - after saving to storage, create database reference
        StorageService.saveChannelPhotoPost(image: image, channelId: channelId, postId: postId, onSuccess: { (imageUrl) in
            
            // Database reference of the new channel post
            let newChannelPostRef = Ref().databaseChannelPostTableRef.child(channelId).child(postId)
            
            // Get todays date to store in dateCreated and lastMessageDate attributes
            let date: Double = Date().timeIntervalSince1970
            
            // Create a dictionary to store the variables
            var dict = ["channelId": channelId, "ownerId": Api.User.currentUserId, "datePosted": date, "imageUrl": imageUrl] as [String : Any]
            
            // Now store the whole dictionary into Firebase database
            newChannelPostRef.setValue(dict) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                } else {
                    onSuccess()
                }
            }
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
    }
    
}
