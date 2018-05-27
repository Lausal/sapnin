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
    
    @IBAction func backButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usePhotoButton_TouchUpInside(_ sender: Any) {
        
    }

}
