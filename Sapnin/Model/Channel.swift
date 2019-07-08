//
//  Channel.swift
//  Sapnin
//
//  Created by Alan Lau on 15/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class Channel {
    var channelName: String
    var ownerId: String
    var dateCreated: Double
    //var users: Dictionary<String, Any>? // Array of users
    
    init(channelName: String, ownerId: String, dateCreated: Double) {
        self.channelName = channelName
        self.ownerId = ownerId
        self.dateCreated = dateCreated
    }

    // Read the User JSON/dict output from database and then assign to local variables for us to utilise
    static func transformChannel(dict: [String: Any]) -> Channel? {
        // Read the JSON and assign to local variable
        guard let channelName = dict["channelName"] as? String,
            let ownerId = dict["ownerId"] as? String,
            let dateCreated = dict["dateCreated"] as? Double else {
                return nil
        }
        
        // Now create a channel instance
        let channel = Channel(channelName: channelName, ownerId: ownerId, dateCreated: dateCreated)
        return channel
    }
    
}
