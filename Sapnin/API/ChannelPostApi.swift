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
import SVProgressHUD

class ChannelPostApi {
    
    var DB_REF_CHANNEL_POSTS = Database.database().reference().child("channel_posts")
    
}
