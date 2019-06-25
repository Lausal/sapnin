//
//  Api.swift
//  Sapnin
//
//  Created by Alan Lau on 07/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation

struct Api {
    static var User = UserApi()
    static var channel = ChannelApi()
    static var userChannel = UserChannelApi()
    static var channelPost = ChannelPostApi()
    static var post = Post()
}
