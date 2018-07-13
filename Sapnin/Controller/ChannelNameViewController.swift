//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelNameViewController: UIViewController {
    
    @IBOutlet weak var channelNameField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set focus on field upon load
        channelNameField.becomeFirstResponder()
        
        // Disable next button by default
        nextButton.isEnabled = false
        
        channelNameField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bug in IOS 11 where next button is faded out when user clicks back from "CreateChannel2ViewController". This solution to enable it will fix it.
        nextButton.isEnabled = false
        nextButton.isEnabled = true
    }
    
    @objc func textFieldDidChange() {
        // Disable next button if field is text empty, otherwise enable
        guard let channelName = channelNameField.text, !channelName.isEmpty else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
    }
    
    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "createChannel2VC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send channel name to CreateChannel2ViewController
        if segue.identifier == "createChannel2VC" {
            let createChannel2VC = segue.destination as! SelectParticipantsViewController
            createChannel2VC.channelName = channelNameField.text
        }
    }
    
    @IBAction func closeButton_TouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
