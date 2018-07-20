//
//  PreviewViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
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
        // Check to see if we display no channel view or with channel view
        guard let userId = Api.user.CURRENT_USER?.uid else {return}
        Api.userChannel.checkIfUserHasChannel(userId: userId) { (userHasChannel) in
            if userHasChannel == true {
                self.performSegue(withIdentifier: "ChannelVC", sender: nil)
            } else {
                self.performSegue(withIdentifier: "NoChannelVC", sender: nil)
            }
        }
    }

}
