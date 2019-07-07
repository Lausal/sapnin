//
//  SignUpStep2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 01/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class SignUpStep2ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        title = "Enter email address"
        
        // Set focus on field upon load
        emailTextField.becomeFirstResponder()
        
        // Disable next button by default
        disabledNextButton()
        
        // Add listener to text field to be able to enable/disable next button
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // Style email text field
        Utility().styleTextField(textfield: emailTextField, text: "Email address")
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = emailTextField.text, !textFieldText.isEmpty else {
            // Disable
            disabledNextButton()
            return
        }
        // Enable
        enableNextButton()
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpStep3VC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send name and email to sign up step 3 VC
        if segue.identifier == "signUpStep3VC" {
            let controller = segue.destination as! SignUpStep3ViewController
            controller.name = self.name
            controller.email = emailTextField.text
        }
    }
    
    // Enable/activate next button
    func enableNextButton() {
        nextButton.setTitle("Next", for: UIControl.State.normal)
        nextButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        nextButton.backgroundColor = BrandColours.PINK
        nextButton.layer.cornerRadius = 25
        nextButton.clipsToBounds = true
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.isEnabled = true
    }
    
    // Disable next button
    func disabledNextButton() {
        nextButton.setTitle("Next", for: UIControl.State.normal)
        nextButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        nextButton.backgroundColor = BrandColours.DISABLED_BUTTON_PINK
        nextButton.layer.cornerRadius = 25
        nextButton.clipsToBounds = true
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.isEnabled = false
    }
    

}
