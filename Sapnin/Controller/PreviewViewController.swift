//
//  PreviewViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import SVProgressHUD

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    var capturedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.capturedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func backButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usePhotoButton_TouchUpInside(_ sender: Any) {
        
        // Show progress indicator
        SVProgressHUD.show(withStatus: "Uploading...")
        
        if let image = self.capturedImage, let imageData = UIImageJPEGRepresentation(image, 0.1) {
            Api.post.addPost(channelId: "-LEqFo9PUxYeK5JBFZgK", imageData: imageData, onSuccess: {
                SVProgressHUD.dismiss()
            })
        }
        
//        // Check to see if we display no channel view or with channel view
//        guard let userId = Api.user.CURRENT_USER?.uid else {return}
//        Api.userChannel.checkIfUserHasChannel(userId: userId) { (userHasChannel) in
//            if userHasChannel == true {
//                self.performSegue(withIdentifier: "ChannelVC", sender: nil)
//            } else {
//                self.performSegue(withIdentifier: "NoChannelVC", sender: nil)
//            }
//        }
    }

}
