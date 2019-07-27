//
//  Ref.swift
//  Sapnin
//
//  Created by Alan Lau on 25/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import Firebase

// Fonts
let ROBOTO_REGULAR = "Roboto-Regular"
let ROBOTO_BOLD = "Roboto-Bold"

// Firebase table reference
let REF_USER_TABLE = "users"
let REF_CHANNEL_TABLE = "channels"
let REF_USER_CHANNEL_TABLE = "user_channels"
let REF_CHANNEL_POST_TABLE = "channel_post"

// Storyboard identifier
let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_CHANNEL = "ChannelViewController"
let IDENTIFIER_LOGIN = "WelcomeViewController"
let IDENTIFER_CHANNEL_NAV_CONTROLLER = "ChannelNavigationController"
let IDENTIFER_LOGIN_NAV_CONTROLLER = "LoginNavigationController"
let IDENTIFIER_CREATE_CHANNEL_NAV_CONTROLLER = "CreateChannelNavigationController"
let IDENTIFIER_CHANNEL_DETAIL = "ChannelDetailViewController"
let IDENTIFIER_PREVIEW = "PreviewViewController"
let IDENTIFIER_IMAGEVC = "ImageViewController"

// Storage
let URL_STORAGE_ROOT = "gs://sapnin-344c6.appspot.com"

class Ref {
    
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    // Database user table reference
    var databaseUserTableRef: DatabaseReference {
        return databaseRoot.child(REF_USER_TABLE)
    }
    
    // Database specific user reference
    func databaseSpecificUserRef(uid: String) -> DatabaseReference {
        return databaseUserTableRef.child(uid)
    }
    
    var databaseChannelTableRef: DatabaseReference {
        return databaseRoot.child(REF_CHANNEL_TABLE)
    }
    
    var databaseChannelPostTableRef: DatabaseReference {
        return databaseRoot.child(REF_CHANNEL_POST_TABLE)
    }
    
    var databaseUserChannelTableRef: DatabaseReference {
        return databaseRoot.child(REF_USER_CHANNEL_TABLE)
    }
    
    func databaseSpecificChannelRef(channelId: String) -> DatabaseReference {
        return databaseChannelTableRef.child(channelId)
    }
    
    /*** Storage Ref ***/
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageChannel: StorageReference {
        return storageRoot.child(REF_CHANNEL_TABLE)
    }
    
    func storageSpecificChannelAvatar(channelId: String) -> StorageReference {
        return storageChannel.child("channelAvatar").child(channelId)
    }
    
    func storageSpecificChannelPost(channelId: String, postId: String) -> StorageReference {
        return storageChannel.child("channelPosts").child(channelId).child(postId)
    }
    
}
