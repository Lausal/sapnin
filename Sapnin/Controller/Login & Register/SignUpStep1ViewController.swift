//
//  SignUpViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 27/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class SignUpStep1ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "What's your name?"
        
        // Set focus on field upon load
        nameTextField.becomeFirstResponder()
        
        // Disable next button by default
        disabledNextButton()
        
        // Add listener to text field to be able to enable/disable next button
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        // Style name text field
        Utility().styleTextField(textfield: nameTextField, text: "Full name")
        
        setupLoginButton()
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = nameTextField.text, !textFieldText.isEmpty else {
            // Disable
            disabledNextButton()
            return
        }
        // Enable
        enableNextButton()
    }
    
    // Navigate back to loginVC
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpStep2VC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send name to sign up step 2 VC
        if segue.identifier == "signUpStep2VC" {
            let controller = segue.destination as! SignUpStep2ViewController
            controller.name = nameTextField.text
        }
    }
    
    func setupLoginButton() {
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_REGULAR, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.TEXT_COLOUR])
        let attributedSubText = NSMutableAttributedString(string: "Log in", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_BOLD, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.PINK])
        attributedText.append(attributedSubText)
        loginButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
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
