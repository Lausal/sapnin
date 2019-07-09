//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class CreateChannelStep2ViewController: UIViewController {
    
    @IBOutlet weak var channelNameTextField: UITextField!
    var createButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        // Set focus on field upon load
        channelNameTextField.becomeFirstResponder()
        
        // Disable next button by default
        createButton?.isEnabled = false
        
        // Add listener to text field to be able to enable/disable next button
        channelNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // Style channel name text field
        Utility().styleTextField(textfield: channelNameTextField, text: "Channel name")
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Channel details"
        
        // Add next button to top right of header
        createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.createButtonDidTapped))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    // Create group - on completion dismiss the view to land back on the channels VC
    @objc func createButtonDidTapped() {
        Api.Channel.createChannel(channelName: channelNameTextField.text!) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Enable create button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = channelNameTextField.text, !textFieldText.isEmpty else {
            // Disable
            self.createButton?.isEnabled = false
            return
        }
        // Enable
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
