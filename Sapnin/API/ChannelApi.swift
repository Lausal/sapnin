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

// Typealias is similar to a variable, but is used to reference closure arguments. In this case the onSuccess will return a Channel object
typealias ChannelCompletion = (Channel) -> Void

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
    func createChannel(channelName: String, channelAvatar: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create unique channelID
        let newChannelId = Ref().databaseChannelTableRef.childByAutoId().key
        
        // Database reference of the new channel
        let newChannelRef = Ref().databaseChannelTableRef.child(newChannelId)
        
        // Get todays date to store in dateCreated and lastMessageDate attributes
        let date: Double = Date().timeIntervalSince1970
        
        // Create a dictionary to store the variables
        var dict = ["channelId": newChannelId, "ownerId": Api.User.currentUserId, "channelName": channelName, "dateCreated": date, "lastMessageDate": date] as [String : Any]
        
        // If avatar is selected, then first store the avatar, retrieve the download URL link and then create dictionary with all the channel information and store in the channels database
        if channelAvatar != nil {
            // First store the avatar into Storage and return a downloadUrl of the stored image
            StorageService.saveChannelAvatar(image: channelAvatar!, channelId: newChannelId, onSuccess: { (avatarUrl) in
                
                // Add the channelAvatarUrl to the dictionary
                dict["channelAvatarUrl"] = avatarUrl
                
                // Now store the whole dictionary into Firebase database
                newChannelRef.setValue(dict) { (error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    } else {
                        // After adding the channel into the "channels" table, also add a reference of the channel ID into the respective "user channels" table of each selected user.
                        let userChannelRef = Ref().databaseUserChannelTableRef.child(Api.User.currentUserId)
                        userChannelRef.updateChildValues([newChannelId: true])
                        onSuccess()
                    }
                }
                
            }) { (error) in
                ProgressHUD.showError(error)
            }
        } else if channelAvatar == nil {
            // If user has not selected an avatar, then just create the channel without the avatar
            newChannelRef.setValue(dict) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                } else {
                    // After adding the channel into the "channels" table, also add a reference of the channel ID into the respective "user channels" table of each selected user.
                    let userChannelRef = Ref().databaseUserChannelTableRef.child(Api.User.currentUserId)
                    userChannelRef.updateChildValues([newChannelId: true])
                    onSuccess()
                }
            }
        }
    }
    
    // Retrieve a specific channel information from Firebase via channel ID
    func observeChannelById(channelId: String, onSuccess: @escaping (ChannelCompletion)) {
        let ref = Ref().databaseSpecificChannelRef(channelId: channelId)
        
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary <String, Any> {
                if let channel = Channel.transformChannel(dict: dict) {
                    onSuccess(channel)
                }
            }
        }
    }
}
