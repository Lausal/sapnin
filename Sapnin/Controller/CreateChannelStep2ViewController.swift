//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class CreateChannelStep2ViewController: UIViewController {
    
    @IBOutlet weak var channelAvatar: UIImageView!
    @IBOutlet weak var channelNameTextField: UITextField!
    var createButton: UIBarButtonItem?
    var selectedChannelAvatar: UIImage?
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        setupNavigationBar()
        setupChannelAvatar()
        
        // Set focus on field upon load
        channelNameTextField.becomeFirstResponder()
        
        // Disable next button by default
        createButton?.isEnabled = false
        
        // Add listener to text field to be able to enable/disable next button
        channelNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // Style channel name text field
        Utility().styleTextField(textfield: channelNameTextField, text: "Channel name")
    }
    
    // Set up channel avatar imageview
    func setupChannelAvatar() {
        // Make logo circular
        channelAvatar.layer.cornerRadius = 60
        channelAvatar.clipsToBounds = true
        
        // Enable tapable gesture - call "presentPicker" function on tap
        channelAvatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(channelAvatarDidTapped))
        channelAvatar.addGestureRecognizer(tapGesture)
    }
    
    // Handles when user taps on the channel avatar - open up a stickersheet with options to take a photo or choose from existing photo library
    @objc func channelAvatarDidTapped() {
        
        let actionSheet = UIAlertController()
        
        // Show camera option
        let camera = UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default) { (_) in
            // This checks if camera is available on phone
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        
        // Show photo library option
        let photoLibrary = UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default) { (_) in
            // This checks if photo library is available on phone
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        
        // Show cancel option
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // Add options to actionsheet
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        // Show picker
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Set up navigation bar/header
    func setupNavigationBar() {
        navigationItem.title = "Channel details"
        
        // Add next button to top right of header
        createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.createButtonDidTapped))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    // Create group - on completion dismiss the view to land back on the channels VC
    @objc func createButtonDidTapped() {
        //ProgressHUD.show("Loading...")
        
        if selectedChannelAvatar == nil {
            print("no image")
        }
        
        //Api.Channel.createChannel(channelName: <#T##String#>, imageData: <#T##Data?#>, onSuccess: <#T##() -> Void#>)
        
    }
    
    // Enable create button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = channelNameTextField.text, !textFieldText.isEmpty else {
            // Disable button
            self.createButton?.isEnabled = false
            return
        }
        // Enable button
        self.createButton?.isEnabled = true
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Send channel name to "createChannelStep2VC"
//        if segue.identifier == "createChannelStep2VC" {
//            let controller = segue.destination as! CreateChannelStep2ViewController
//            controller.channelName = channelNameTextField.text
//        }
//    }
    
}

// Handle image and camera picker
extension CreateChannelStep2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Handles when user finishes picking or taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Extract image from selection/camera. The photo is extracted from 'info' dictionary response once user takes a picture or selects a picture from photo library
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage? {
            
            print("picked")
            
            // Assign the image to "selectChannelAvatar" to be utilised in the createChannel Firebase method
            self.selectedChannelAvatar = image
            
            // Set logo imageview to selected image
            self.channelAvatar.image = image
            
            // Dismiss photo modal after selection (I.e. user clicks "Choose")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
