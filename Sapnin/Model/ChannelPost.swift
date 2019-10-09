//
//  ChannelPost.swift
//  Sapnin
//
//  Created by Alan Lau on 22/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation

class ChannelPost {
    var postId: String
    var channelId: String
    var ownerId: String
    var datePosted: Double
    var imageUrl: String
    var category: String
    
    init(postId: String, channelId: String, ownerId: String, datePosted: Double, imageUrl: String, category: String) {
        self.postId = postId
        self.channelId = channelId
        self.ownerId = ownerId
        self.datePosted = datePosted
        self.imageUrl = imageUrl
        self.category = category
    }
    
    // Read the User JSON/dict output from database and then assign to local variables for us to utilised
    static func transformChannelPost(dict: [String: Any]) -> ChannelPost? {
        
        // Read the JSON and assign to local variable - these are the mandatory fields
        guard let postId = dict["postId"] as? String,
            let channelId = dict["channelId"] as? String,
            let ownerId = dict["ownerId"] as? String,
            let datePosted = dict["datePosted"] as? Double,
            let imageUrl = dict["imageUrl"] as? String,
            let category = dict["category"] as? String
            else {return nil}
        
        // Now create a channel post instance
        let channelPost = ChannelPost(postId: postId, channelId: channelId, ownerId: ownerId, datePosted: datePosted, imageUrl: imageUrl, category: category)
        
        return channelPost
    }
    
    
    // Read the User Array of JSON/dict output from database and then assign to local variables for us to utilised
    static func transformChannelPosts(posts: [String: Any]) -> [ChannelPost] {
        
        // Read the JSON and assign to local variable - these are the mandatory fields
        
        var channelPosts = [ChannelPost]()
        
        for key in posts.keys{
            if let dict = posts[key] as? [String:Any]{
                guard let postId = dict["postId"] as? String,
                    let channelId = dict["channelId"] as? String,
                    let ownerId = dict["ownerId"] as? String,
                    let datePosted = dict["datePosted"] as? Double,
                    let imageUrl = dict["imageUrl"] as? String,
                    let category = dict["category"] as? String
                    else {continue}
                
                // Now create a channel post instance
                let channelPost = ChannelPost(postId: postId, channelId: channelId, ownerId: ownerId, datePosted: datePosted, imageUrl: imageUrl, category: category)
                channelPosts.append(channelPost)
            }
        }
        
        
        return channelPosts
    }
    
    
    // Read the User JSON/dict output from database and then assign to local variables for us to utilised
    static func transformChannelStories(dict: [String: Any]) -> [ChannelPost]? {
        
        // Read the JSON and assign to local variable - these are the mandatory fields
        var channelPosts = [ChannelPost]()
        
        for key in dict.keys{
            if let cp /*cp => Channel Post*/ = dict[key] as? [String:Any]{
                guard let postId = cp["postId"] as? String,
                    let channelId = cp["channelId"] as? String,
                    let ownerId = cp["ownerId"] as? String,
                    let datePosted = cp["datePosted"] as? Double,
                    let imageUrl = cp["imageUrl"] as? String,
                    let category = cp["category"] as? String
                    else {return nil}
                
                // Now create a channel post instance
                let channelPost = ChannelPost(postId: postId, channelId: channelId, ownerId: ownerId, datePosted: datePosted, imageUrl: imageUrl, category: category)
                
                channelPosts.append(channelPost)
            }
        }
        
        return channelPosts
    }
    
}
