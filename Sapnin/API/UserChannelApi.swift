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

class UserChannel {
    
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
    
}
