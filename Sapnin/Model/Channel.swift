//
//  Channel.swift
//  Sapnin
//
//  Created by Alan Lau on 15/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class Channel {
    var channelId: String
    var channelName: String
    var ownerId: String
    var dateCreated: Double
    var lastMessageDate: Double
    //var users: Dictionary<String, Any>? // Array of users
    
    init(channelId: String, channelName: String, ownerId: String, dateCreated: Double, lastMessageDate: Double) {
        self.channelId = channelId
        self.channelName = channelName
        self.ownerId = ownerId
        self.dateCreated = dateCreated
        self.lastMessageDate = lastMessageDate
    }

    // Read the User JSON/dict output from database and then assign to local variables for us to utilise
    static func transformChannel(dict: [String: Any]) -> Channel? {
        // Read the JSON and assign to local variable
        guard let channelId = dict["channelId"] as? String,
            let channelName = dict["channelName"] as? String,
            let ownerId = dict["ownerId"] as? String,
            let dateCreated = dict["dateCreated"] as? Double,
            let lastMessageDate = dict["lastMessageDate"] as? Double else {
                return nil
        }
        
        // Now create a channel instance
        let channel = Channel(channelId: channelId, channelName: channelName, ownerId: ownerId, dateCreated: dateCreated, lastMessageDate: lastMessageDate)
        return channel
    }
    
}
