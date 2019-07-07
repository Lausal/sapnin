//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class CreateChannelStep1ViewController: UIViewController {
    
    @IBOutlet weak var channelNameTextField: UITextField!
    var nextButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        // Set focus on field upon load
        channelNameTextField.becomeFirstResponder()
        
        // Disable next button by default
        nextButton?.isEnabled = false
        
        // Add listener to text field to be able to enable/disable next button
        channelNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // Style channel name text field
        Utility().styleTextField(textfield: channelNameTextField, text: "Channel name")
    }
    
    func setupNavigationBar() {
        navigationItem.title = "New channel"
        
        // Add next button to top right of header
        nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextButtonDidTapped))
        self.navigationItem.rightBarButtonItem = nextButton
        
        // Add cancel button to top left of header
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelButtonDidTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func nextButtonDidTapped() {
        self.performSegue(withIdentifier: "createChannelStep2VC", sender: nil)
    }
    
    // Revert back to channel VC when cancel is tapped
    @objc func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = channelNameTextField.text, !textFieldText.isEmpty else {
            // Disable
            self.nextButton?.isEnabled = false
            return
        }
        // Enable
        self.nextButton?.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send channel name to "createChannelStep2VC"
        if segue.identifier == "createChannelStep2VC" {
            let controller = segue.destination as! CreateChannelStep2ViewController
            controller.channelName = channelNameTextField.text
        }
    }
    
}
