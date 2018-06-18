//
//  PhotoViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 18/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    
    var pictureDuration: Double = 5
    var currentDuration: Double = 0
    var currentImageNumber = 0
    let numberOfImages = 4
    var imageNames = ["selfie_image1", "selfie_image2", "selfie_image3", "selfie_image4"]
    var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImage()
        setupPostImage()
        
        // Start timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.setProgressBar), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupProfileImage() {
        // Add border to profile image
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        // Set profile iamge
        profileImage.image = UIImage(named: "profile_image")
    }
    
    func setupPostImage() {
        // Add tap gesture to post image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postImage_TouchUpInside))
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Set post Image
        postImage.image = UIImage(named: imageNames[currentImageNumber])
    }
    
    @objc func postImage_TouchUpInside() {
        // If there're still more images, then display. Need to -1 since array starts at 0
        if currentImageNumber < numberOfImages-1 {
            displayNextImage()
        }
    }
    
    func displayNextImage() {
        currentImageNumber += 1
        postImage.image = UIImage(named: imageNames[currentImageNumber])
        
        // Reset progress bar index
        currentDuration = 0
    }
    
    @objc func setProgressBar() {
        // If the duration of the image timer is up (5s), then display next image if applicable
        if currentDuration > pictureDuration {
            if currentImageNumber < numberOfImages-1 {
                // If there're still more images, then display. Need to -1 since array starts at 0
                displayNextImage()
            } else {
                // When all images have been played, stop the timer and then show voting view controller
                timer?.invalidate()
                self.performSegue(withIdentifier: "VoteViewController", sender: nil)
            }
        } else {
            // Update progress bar
            progressBar.progress = Float(currentDuration) / Float(pictureDuration - 0.01)
            
            // Increment the duration
            currentDuration += 0.01
        }
        
        
    }

}
