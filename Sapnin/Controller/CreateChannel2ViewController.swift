//
//  CreateChannel2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class CreateChannel2ViewController: UIViewController {
    
    @IBOutlet weak var channelNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set focus on field upon load
        channelNameField.becomeFirstResponder()
    }
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        
    }
    
}
