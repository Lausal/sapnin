//
//  SettingsViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 03/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import StoreKit

class SettingsViewController: UIViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.nameLabel.text = user.name
            if let profileUrl = URL(string: user.profileImageUrl!) {
                self.profileImage.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func closeButton_TouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileButton_TouchUpInside(_ sender: Any) {
        // Setup and show menu
        let actionSheet = UIAlertController()
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        let takePhotoActionButton = UIAlertAction(title: "Take photo", style: .default) { _ in
            self.handleImagePicker(type: "camera")
        }
        
        let photoLibraryActionButton = UIAlertAction(title: "Photo library", style: .default) { _ in
            self.handleImagePicker(type: "photoLibrary")
        }
        
        actionSheet.addAction(cancelActionButton)
        actionSheet.addAction(takePhotoActionButton)
        actionSheet.addAction(photoLibraryActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Handling of photo library or camera picker
    func handleImagePicker(type: String) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if type == "photoLibrary" {
            imagePicker.sourceType = .photoLibrary
        } else if type == "camera" {
            imagePicker.sourceType = .camera
        }
        
        // Allow user crop after take picture
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func rateButton_TouchUpInside(_ sender: Any) {
        // Apple provides library to show rate us popup
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBAction func tellAFriendButton_TouchUpInside(_ sender: Any) {
        
        // Text to share
        let text = "Download Sapnin now lorem ipsum dolor sit amet"
        
        // UIActivityViewController is the iOS sharing pop up functionality
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func accountButton_TouchUpInside(_ sender: Any) {
        
        // Setup and show menu
        let actionSheet = UIAlertController()
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        let logoutActionButton = UIAlertAction(title: "Logout", style: .default) { _ in
            AuthService.logout(onSuccess: {
                // Show login screen upon logging out - use present to show page without nav bar
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(loginVC, animated: true, completion: nil)
                print("User logged out")
            }) { (error) in
                print(error!)
            }
        }
        
        // Set colour of logout button
        logoutActionButton.setValue(UIColor.red, forKey: "titleTextColor")
        
        actionSheet.addAction(cancelActionButton)
        actionSheet.addAction(logoutActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func helpButton_TouchUpInside(_ sender: Any) {
        
    }
    
    @IBAction func twitterButton_TouchUpInside(_ sender: Any) {
        openSocialMediaApplication(type: "twitter", screenName: "luketdooley", id: nil)
    }
    
    @IBAction func instagramButton_TouchUpInside(_ sender: Any) {
        openSocialMediaApplication(type: "instagram", screenName: "lukestar01", id: nil)
    }
    
    @IBAction func facebookButton_TouchUpInside(_ sender: Any) {
        openSocialMediaApplication(type: "facebook", screenName: "luketdooley", id: "518028985")
    }
    
    func openSocialMediaApplication(type: String, screenName: String, id: String?) {
        let appURL: NSURL
        let webURL: NSURL
        
        if type == "facebook" {
            appURL = NSURL(string: "fb://profile/\(id!)")!
            webURL = NSURL(string: "https://facebook.com/\(screenName)")!
        } else if type == "instagram" {
            appURL = NSURL(string: "instagram://user?username=\(screenName)")!
            webURL = NSURL(string: "https://instagram.com/\(screenName)")!
        } else {
            // Twitter
            appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
            webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        }
        
        // Open the native app if available
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            // Otherwise redirect to Safari because the user doesn't have Facebook
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    
    @IBAction func termsButton_TouchUpInside(_ sender: Any) {
        if let url = URL(string: "https://www.barclays.co.uk/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func privacyButton_TouchUpInside(_ sender: Any) {
        if let url = URL(string: "https://www.barclays.co.uk/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Setting status bar colour to black
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

// Handle image and camera picker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Extract image from selection/camera, this is taken from 'info' dictionary response once user takes a picture or selects a picture from photo library
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage? {
            self.selectedImage = image
            profileImage.image = image
            
            saveUserInformation()
        }
    }
    
    func saveUserInformation() {
        if let profileImage = self.profileImage.image {
            SVProgressHUD.show(withStatus: "Saving...")
            
            let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
            AuthService.updateUserInformation(imageData: imageData!, onSuccess: {
                
                // Dismiss photo modal after selection
                self.dismiss(animated: true, completion: nil)
                
                SVProgressHUD.showSuccess(withStatus: "Profile saved")
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error)
            })
            
        }
    }
}
