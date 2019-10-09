//
//  PhotoViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 18/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    
    var storyDuration: Double = 5
    var currentDuration: Double = 0
    var currentImageNumber = 0
    var imageNames = ["selfie_image1", "selfie_image2", "selfie_image3", "selfie_image4"]
    var timer: Timer? = nil
    var channelId : String!
    
    var storiesList = [ChannelPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImage()
        if channelId != nil{
            observeChannelStories()
        }else{
            setupPostImage()
        }
        
        let downSwipeGesture = UISwipeGestureRecognizer.init()
        downSwipeGesture.direction = .down
        downSwipeGesture.addTarget(self, action: #selector(dismissStory))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(downSwipeGesture)
        
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
    
    @objc func dismissStory(){
        timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func observeChannelStories(){
        
        Api.ChannelPost.getAllStoriesForChannel(channelId: channelId) { (channelPosts) in
            if channelPosts != nil{
                self.storiesList = channelPosts!
            }
            self.setupPostImage()
        }
    }
    
    
    // Closes the modal
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        timer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupProfileImage() {
        // Add border to profile image
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        // Set profile iamge
        profileImage.image = UIImage(named: "no_profile_icon")
    }
    
    func setupPostImage() {
        // Add tap gesture to post image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postImage_TouchUpInside(gestureRecognizer:)))
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Set post Image
        
        if storiesList.count > 0{
            postImage.sd_setImage(with: URL.init(string: storiesList.first!.imageUrl), completed: nil)
            
            Api.User.observeSpecificUserById(uid: storiesList.first!.ownerId) { (user) in
                if user.profilePictureUrl != nil{
                    self.profileImage.sd_setImage(with: URL.init(string: user.profilePictureUrl!), completed: nil)
                }
            }
            
            
        }else{
            postImage.image = UIImage(named: "")
        }
    }
    
    // Switch to next image or dismiss on tap of image
    @objc func postImage_TouchUpInside(gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.recognized
        {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            if location.x < self.view.bounds.width / 2{
                if currentImageNumber > 0{
                    displayPreviousImage()
                }
            }else{
                // If there're still more images, then display. Need to -1 since array starts at 0 - Otherwise if no more image then dismiss the modal
                if currentImageNumber < self.storiesList.count-1{
                    displayNextImage()
                } else {
                    timer?.invalidate()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func displayPreviousImage() {
        currentImageNumber -= 1
        postImage.sd_setImage(with: URL.init(string: storiesList[currentImageNumber].imageUrl), completed: nil)
        
        Api.User.observeSpecificUserById(uid: storiesList[currentImageNumber].ownerId) { (user) in
            if user.profilePictureUrl != nil{
                self.profileImage.sd_setImage(with: URL.init(string: user.profilePictureUrl!), completed: nil)
            }
        }
        
        // Reset progress bar index
        currentDuration = 0
    }
    
    func displayNextImage() {
        currentImageNumber += 1
        postImage.sd_setImage(with: URL.init(string: storiesList[currentImageNumber].imageUrl), completed: nil)
        Api.User.observeSpecificUserById(uid: storiesList[currentImageNumber].ownerId) { (user) in
            if user.profilePictureUrl != nil{
                self.profileImage.sd_setImage(with: URL.init(string: user.profilePictureUrl!), completed: nil)
            }
        }
        // Reset progress bar index
        currentDuration = 0
    }
    
    @objc func setProgressBar() {
        // If the duration of the image timer is up (5s), then display next image if applicable
        if currentDuration > storyDuration {
            // If there're still more images, then display next image (Need to -1 since array starts at 0)
            if currentImageNumber <  self.storiesList.count-1{
                displayNextImage()
            } else {
                // When all images have been played, stop the timer and then dismiss the modal
                timer?.invalidate()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            // Update progress bar
            progressBar.progress = Float(currentDuration) / Float(storyDuration - 0.01)
            
            // Increment the duration
            currentDuration += 0.01
        }
        
        
    }

}

extension StoriesViewController : UIGestureRecognizerDelegate{
    
    
    
}
