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
import ProgressHUD

class ChannelApi {
    
//    func createChannel(channelName: String, users: [String: Bool], onSuccess: @escaping () -> Void) {
//        let newChannelId = DB_REF_CHANNELS.childByAutoId().key
//        let newChannelRef = DB_REF_CHANNELS.child(newChannelId)
//
//        guard let currentUser = Api.User.CURRENT_USER else{
//            return
//        }
//        let currentUserId = currentUser.uid
//
//        //let users = ["1": true, "2": true, "3": true]
//        let channelData = ["ownerId": currentUserId, "channelName": channelName, "users": users] as [String : Any]
//
//        newChannelRef.setValue(channelData) { (error, ref) in
//            if error != nil {
//                SVProgressHUD.showError(withStatus: error!.localizedDescription)
//                return
//            } else {
//                Api.userChannel.addToUserChannel(userId: currentUserId, channelId: newChannelId, onSuccess: {
//                    onSuccess()
//                })
//            }
//        }
//    }
    
//    // Getting the channel details
//    func observeChannels(channelId: String, onSuccess: @escaping (ChannelModel) -> Void) {
//        DB_REF_CHANNELS.child(channelId).observeSingleEvent(of: .value) { (snapshot) in
//            if let dict = snapshot.value as? [String: Any] {
//                let channel = ChannelModel.transformChannel(dict: dict, key: snapshot.key)
//                onSuccess(channel)
//            }
//        }
//    }
//
//    func deleteChannel(channelId: String, onSuccess: @escaping () -> Void) {
//        DB_REF_CHANNELS.child(channelId).removeValue()
//        onSuccess()
//    }
    
    
    ////
    
    // Function to create a new channel entity in Firebase
    func createChannel(channelName: String, onSuccess: @escaping () -> Void) {
        
        ProgressHUD.show("Loading...")
        
        // ID reference of the channel
        let newChannelId = Ref().databaseChannelTableRef.childByAutoId().key
        let newChannelRef = Ref().databaseChannelTableRef.child(newChannelId)
        
        // Get todays date
        let date: Double = Date().timeIntervalSince1970
        
        // Create a dictionary to store the variables
        let dict = ["ownerId": Api.User.currentUserId, "channelName": channelName, "date": date] as [String : Any]
        
        // Add new channel to channels Firebase entity table
        newChannelRef.setValue(dict) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            } else {
                ProgressHUD.dismiss()
                
                // After adding the channel into the "channels" table, also add reference of the channel ID into the respective user channel table of each user.
                let currentUserChannelRef = Database.database().reference().child(REF_USER_CHANNEL_TABLE).child(Api.User.currentUserId).child(newChannelId)
                currentUserChannelRef.updateChildValues(dict)
                onSuccess()
            }
        }
    }
}
