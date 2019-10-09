//
//  PreviewViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    
    var selectedImage: UIImage!
    var channelId: String!
    var channelName: String!
    var userIDList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    // Set up the view
    func setupViewController() {
        // Make submit butto round
        submitButton.layer.cornerRadius = 28
        submitButton.clipsToBounds = true
        
        // Set image as the selected/captured image
        photo.image = self.selectedImage
    }
    
    // Hide status bar on this page
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Store and send image to database when submit is pressed - then return to the channel detail VC
    @IBAction func submitButtonDidTapped(_ sender: Any) {
        ProgressHUD.show("Loading...")
        
        // Save image into Firebase
        Api.ChannelPost.submitChannelPost(channelId: channelId, image: photo.image!, onSuccess: {
            ProgressHUD.dismiss()
            
            
            /*** Send push notification to each user in group to nofity new post ***/
            
            // Get current user information
            Api.User.observeSpecificUserById(uid: Api.User.currentUserId, onSuccess: { (currentUser) in
                // Now loop through and grab each of the user information in the group based on their ID's so we can get the token and send push accordingly
                for user in self.userIDList {
                    // Get the user information by passing userID
                    Api.User.observeSpecificUserById(uid: user.keys.first!, onSuccess: { (user) in
                        // If the user has a tokenID (I.e. push turned on), then send push notification
                        if user.tokenID != nil {
                            sendPushNotifications(channelName: self.channelName, fromUser: currentUser, toUser: user, badge: 1)
                        }
                    })
                }
            })
            
            if let tabbar = self.view.window!.rootViewController as? UITabBarController{
                tabbar.selectedIndex = 0
            }
            
            //Update last message date in Channel
            Api.Channel.updateChannelLastMessage(channelId: self.channelId)
            // On completion, dismiss the modal and return to the channel detail VC
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
    }
    

}
