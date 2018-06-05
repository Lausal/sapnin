//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class CreateChannel1ViewController: UIViewController {
    
    @IBOutlet weak var channelNameField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set focus on field upon load
        channelNameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Bug in IOS 11 where next button is faded out when user clicks back from "CreateChannel2ViewController". This solution to enable it will fix it.
        nextButton.isEnabled = false
        nextButton.isEnabled = true
    }
    
    @IBAction func nextButton_TouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "selectParticipantsVC", sender: nil)
    }
    
    @IBAction func closeButton_TouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
