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

        setupPicker()
        setupNavigationBar()
        setupChannelAvatar()
        
        // Set focus on field upon load
        channelNameTextField.becomeFirstResponder()
        
        // Disable next button by default
        createButton?.isEnabled = false
        
        // Add listener to text field to be able to enable/disable next button
        channelNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        // Style channel name text field
        Utility().styleTextField(textfield: channelNameTextField, text: "Channel name")
    }
    
    // Set up photo picker
    func setupPicker() {
        picker.delegate = self
        picker.allowsEditing = true
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
        createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.createButtonDidTapped))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    // Create group on Firebase - on completion dismiss the view and land back on the channels VC
    @objc func createButtonDidTapped() {
        
        ProgressHUD.show("Loading...")
        
        if let img = self.selectedChannelAvatar {
            // If avatar is picked, send channel name and avatar to createChannel function to store on Firebase
            Api.Channel.createChannel(channelName: self.channelNameTextField.text!, channelAvatar: img, onSuccess: {
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }) { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            }
        } else {
            // If avatar is not picked, then don't send avatar but still store the channel in Firebase
            Api.Channel.createChannel(channelName: self.channelNameTextField.text!, channelAvatar: nil, onSuccess: {
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }) { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            }
        }
        
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
    
}

// Handle image and camera picker
extension CreateChannelStep2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Handles when user finishes picking or taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Extract image from selection/camera. The photo is extracted from 'info' dictionary response once user takes a picture or selects a picture from photo library
        if let image = info[.editedImage] as? UIImage? {
            
            // Assign the image to "selectChannelAvatar" to be utilised in the createChannel Firebase method
            self.selectedChannelAvatar = image
            
            // Set logo imageview to selected image
            self.channelAvatar.image = image
            
            // Dismiss photo modal after selection (I.e. user clicks "Choose")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
