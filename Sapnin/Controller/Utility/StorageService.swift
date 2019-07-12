//
//  StorageService.swift
//  Sapnin
//
//  Created by Alan Lau on 10/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
import AVFoundation

class StorageService {
    
    // Save channel avatar to storage, and then return a download URL link of the image on success
    static func saveChannelAvatar(image: UIImage, channelId: String, onSuccess: @escaping(_ value: String) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Set quality of image before uploading
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return
        }
        
        // Set storage location reference and image type values
        let storageRef = Ref().storageSpecificChannelAvatar(channelId: channelId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // Add image to storage
        storageRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            // After successfully storing to Storage, get the image download URL and pass on success
            storageRef.downloadURL(completion: { (url, error) in
                
                // Get image URL that's been saved into storage
                if let channelAvatarUrl = url?.absoluteString {
                    onSuccess(channelAvatarUrl)
                }
            })
        })
    }
    
}
