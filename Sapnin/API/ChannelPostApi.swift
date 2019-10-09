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

typealias ChannelPostCompletion = (ChannelPost?) -> Void
typealias ChannelAllPostCompletion = ([ChannelPost]) -> Void
typealias ChannelStoriesCompletion = ([ChannelPost]?) -> Void

class ChannelPostApi {
    
    // Function to submit a new post in a channel and set it in Firebase
    func submitChannelPost(channelId: String, image: UIImage, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create unique postId
        let postId = Ref().databaseChannelPostTableRef.childByAutoId().key
        
        // Save photo into storage - after saving to storage, create database reference
        StorageService.saveChannelPhotoPost(image: image, channelId: channelId, postId: postId!, onSuccess: { (imageUrl) in
            
            // Database reference of the new channel post
            let newChannelPostRef = Ref().databaseChannelPostTableRef.child(channelId).child(postId!)
            
            // Get todays date to store in dateCreated and lastMessageDate attributes
            let date: Double = Date().timeIntervalSince1970
            
            // Create a dictionary to store the variables
            var dict = ["postId": postId, "channelId": channelId, "ownerId": Api.User.currentUserId, "datePosted": date, "imageUrl": imageUrl, "category":""] as [String : Any]
            
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
    
    // Get all the posts from a channel from Firebase and return as channel post object
    func getChannelPosts(channelId: String, onSuccess: @escaping (ChannelPostCompletion)) {
        
        let ref = Ref().databaseChannelPostTableRef.child(channelId)
        
        ref.queryOrdered(byChild: "datePosted").observe(.childAdded, with: { (snapshot) -> Void in
            if let dict = snapshot.value as? Dictionary <String, Any> {
                if let channelPost = ChannelPost.transformChannelPost(dict: dict) {
                    onSuccess(channelPost)
                }else{
                    onSuccess(nil)
                }
            }else{
                onSuccess(nil)
            }
        })
        
//        ref.observe(.childAdded) { (snapshot) in
//            if let dict = snapshot.value as? Dictionary <String, Any> {
//                if let channelPost = ChannelPost.transformChannelPost(dict: dict) {
//                    onSuccess(channelPost)
//                }
//            }
//        }
        
    }
    
    // Get all the posts from a channel from Firebase and return as channel post object
    func getAllChannelPosts(channelId: String, onSuccess: @escaping (ChannelAllPostCompletion)) {
        
        let ref = Ref().databaseChannelPostTableRef.child(channelId)
        
        ref.queryOrdered(byChild: "datePosted").observe(.value, with: { (snapshot) -> Void in
            if let dict = snapshot.value as?  [String: Any] {
//                let channelPosts =  {
                    onSuccess(ChannelPost.transformChannelPosts(posts: dict))
//                }else{
//                    onSuccess([ChannelPost]())
//                }
                print("sdfsdf")
            }else{
                onSuccess([ChannelPost]())
            }
        })
        
        //        ref.observe(.childAdded) { (snapshot) in
        //            if let dict = snapshot.value as? Dictionary <String, Any> {
        //                if let channelPost = ChannelPost.transformChannelPost(dict: dict) {
        //                    onSuccess(channelPost)
        //                }
        //            }
        //        }
        
    }
    
    //Get all Stories for Channel
    func getAllStoriesForChannel(channelId: String, onSuccess: @escaping (ChannelStoriesCompletion)) {
        let ref = Ref().databaseChannelPostTableRef.child(channelId)
        
        //-86000 (24 * 60 * 60) is for getting posts other than last 24 hours.
        let date: Double = (Date().timeIntervalSince1970)-86000
        
        ref.queryOrdered(byChild: "datePosted").queryStarting(atValue: date).observe(.value, with: { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                if let channelPosts = ChannelPost.transformChannelStories(dict: dict) {
                    onSuccess(channelPosts)
                }else{
                    onSuccess(nil)
                }
            }else{
                onSuccess(nil)
            }
        })
    }
    
    // Get all the posts from a channel from Firebase and return as channel post object
    func updateChannelPostCategory(channelId: String, postId: String, category:String) {
        let ref = Ref().databaseChannelPostTableRef.child(channelId).child(postId)
        ref.updateChildValues(["category":category])
    }
    
    
}
