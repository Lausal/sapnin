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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Store and send image to database
    @IBAction func submitButtonDidTapped(_ sender: Any) {
        
        ProgressHUD.show("Loading...")
        
        Api.ChannelPost.submitChannelPost(channelId: channelId, image: photo.image!, onSuccess: {
            ProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.showError(error)
        }
        
    }
    

}
