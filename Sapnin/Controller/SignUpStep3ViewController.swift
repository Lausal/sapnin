//
//  SignUpStep2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 29/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpStep3ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var name: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        title = "Enter password"
        
        // Set focus on field upon load
        passwordTextField.becomeFirstResponder()
        
        // Disable next button by default
        disabledNextButton()
        
        // Add listener to text field to be able to enable/disable next button
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        setupPasswordTextField()
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = passwordTextField.text, !textFieldText.isEmpty else {
            // Disable
            disabledNextButton()
            return
        }
        // Enable
        enableNextButton()
    }
    
    // Configure email text field
    func setupPasswordTextField() {
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
        passwordTextField.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.font = UIFont(name: "Roboto-Regular", size: 14)
        
        // Set left and right padding of text field input
        passwordTextField.paddingLeft = 16
        passwordTextField.paddingRight = 16
        
        // Set placeholder styling
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
        passwordTextField.attributedPlaceholder = placeholderAttr
        
        // Specify text colour
        passwordTextField.textColor = BrandColours.PINK
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        ProgressHUD.show("Loading...")
        
        Api.User.signUp(name: self.name, email: self.email, password: self.passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss() // Dismiss loading wheel on completion
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        
        // Dismiss keyboard
        self.view.endEditing(true)
        
        // Add user to Firebase database
        self.signUp(onSuccess: {
            
            // Call the configureIntialViewController function in appdelegate to navigate to appropriate screen - in this case it would be the channels screen
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
            
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    // Enable/activate next button
    func enableNextButton() {
        signUpButton.setTitle("Sign up", for: UIControl.State.normal)
        signUpButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        signUpButton.backgroundColor = BrandColours.PINK
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
        signUpButton.isEnabled = true
    }
    
    // Disable next button
    func disabledNextButton() {
        signUpButton.setTitle("Sign up", for: UIControl.State.normal)
        signUpButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        signUpButton.backgroundColor = BrandColours.DISABLED_BUTTON_PINK
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
        signUpButton.isEnabled = false
    }
}
