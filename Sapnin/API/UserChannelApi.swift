//
//  UserChannelApi.swift
//  Sapnin
//
//  Created by Alan Lau on 12/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class UserChannelApi {
    
    var DB_REF_USER_CHANNELS = Database.database().reference().child("user_channels")
    
    func addToUserChannel(userId: String, channelId: String, onSuccess: @escaping () -> Void) {
        let ref = DB_REF_USER_CHANNELS.child(userId).child(channelId)
        ref.setValue(true, withCompletionBlock: { (error, ref) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            } else {
                onSuccess()
            }
        })
    }
    
    // Get all channel ID's associated to a user ID
    func observeUserChannel(userId: String, onSuccess: @escaping (String) -> Void) {
        let ref = DB_REF_USER_CHANNELS.child(userId).observe(.childAdded) { (snapshot) in
            onSuccess(snapshot.key)
        }
    }
    
    func checkIfUserHasChannel(userId: String, userHasChannels: @escaping (Bool) -> Void) {
        let query = DB_REF_USER_CHANNELS.child(userId)
        query.observe(.value) { (snapshot) in
            print(userId)
            if snapshot.exists() {
                userHasChannels(true)
            } else {
                userHasChannels(false)
            }
        }
    }
    
    ////////
    
    // Function to get all the corresponding users channels
    func getUserChannels(uid: String, onSuccess: @escaping (ChannelCompletion)) {
        
        // First grab all the channel ID's from "user_channels" table corresponding to the current user ID
        let ref = Ref().databaseUserChannelTableRef.child(uid)
        ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            guard let dict = snapshot.value as? [String: Bool] else { return }
            
            // After grabbing all channel Id's from the user, loop through each channel ID and fetch the corresponding channel detail from the "channels" table
            dict.forEach({ (arg) in
                
                // key is the channel Id, and value = true or false (Corresponds to the table)
                let (key, value) = arg
                Api.Channel.getSpecificChannelInfo(channelId: key, onSuccess: { (channel) in
                    onSuccess(channel)
                })
            })
        }
    }
    
}
