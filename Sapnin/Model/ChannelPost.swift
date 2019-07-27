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
    
    init(postId: String, channelId: String, ownerId: String, datePosted: Double, imageUrl: String) {
        self.postId = postId
        self.channelId = channelId
        self.ownerId = ownerId
        self.datePosted = datePosted
        self.imageUrl = imageUrl
    }
    
    // Read the User JSON/dict output from database and then assign to local variables for us to utilised
    static func transformChannelPost(dict: [String: Any]) -> ChannelPost? {
        
        // Read the JSON and assign to local variable - these are the mandatory fields
        guard let postId = dict["postId"] as? String,
            let channelId = dict["channelId"] as? String,
            let ownerId = dict["ownerId"] as? String,
            let datePosted = dict["datePosted"] as? Double,
            let imageUrl = dict["imageUrl"] as? String else {
                return nil
        }
        
        // Now create a channel post instance
        let channelPost = ChannelPost(postId: postId, channelId: channelId, ownerId: ownerId, datePosted: datePosted, imageUrl: imageUrl)
        
        return channelPost
    }
    
}
