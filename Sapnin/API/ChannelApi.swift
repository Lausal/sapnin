//
//  ChannelsApi.swift
//  Sapnin
//
//  Created by Alan Lau on 09/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class ChannelApi {
    
    var DB_REF_CHANNELS = Database.database().reference().child("channels")
    
    func createChannel(onSuccess: @escaping () -> Void) {
        let newChannelId = DB_REF_CHANNELS.childByAutoId().key
        let newChannelRef = DB_REF_CHANNELS.child(newChannelId)
        
        guard let currentUser = Api.user.CURRENT_USER else{
            return
        }
        let currentUserId = currentUser.uid
        
        let users = ["1": true, "2": true, "3": true]
        let channelData = ["ownerId": currentUserId, "channelName": "Gym", "users": users] as [String : Any]
        
        newChannelRef.setValue(channelData) { (error, ref) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            } else {
                onSuccess()
            }
        }
        
    }
    
}