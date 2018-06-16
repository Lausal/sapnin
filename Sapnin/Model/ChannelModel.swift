//
//  Channel.swift
//  Sapnin
//
//  Created by Alan Lau on 15/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

class ChannelModel {
    var channelId: String?
    var channelName: String?
    var ownerId: String?
    var users: Dictionary<String, Any>? // Array of users
}

extension ChannelModel {
    static func transformChannel(dict: [String: Any], key: String) -> ChannelModel {
        let channel = ChannelModel()
        channel.channelId = key
        channel.channelName = dict["channelName"] as? String
        channel.ownerId = dict["ownerId"] as? String
        channel.users = dict["users"] as? Dictionary<String, Any>
        return channel
    }
}
