//
//  EmailLoginViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 27/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        // Disable login button by default
        disabledLoginButton()
        
        // Add listener to text field to be able to enable/disable next button
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
    }
    
    // Enable login button if both email and password text field are filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let emailTextFieldText = emailTextField.text, let passwordTextFieldText = passwordTextField.text, !emailTextFieldText.isEmpty, !passwordTextFieldText.isEmpty else {
            // Disable
            disabledLoginButton()
            return
        }
        // Enable
        enableLoginButton()
    }
    
    // Configure email text field
    func setupEmailTextField() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
        emailTextField.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
        emailTextField.layer.cornerRadius = 5
        emailTextField.font = UIFont(name: "Roboto-Regular", size: 14)
        
        // Set left and right padding of text field input
        emailTextField.addPadding(.both(16))
        
        // Set placeholder styling
        let placeholderAttr = NSAttributedString(string: "Email address", attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
        emailTextField.attributedPlaceholder = placeholderAttr
        
        // Specify text colour
        emailTextField.textColor = BrandColours.PINK
    }
    
    // Configure password text field
    func setupPasswordTextField() {
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
        passwordTextField.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.font = UIFont(name: "Roboto-Regular", size: 14)
        
        // Set left and right padding of text field input
        passwordTextField.addPadding(.both(16))
        
        // Set placeholder styling
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
        passwordTextField.attributedPlaceholder = placeholderAttr
        
        // Specify text colour
        passwordTextField.textColor = BrandColours.PINK
    }
    
    // Configure sign up button
    func setupSignUpButton() {
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_REGULAR, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.TEXT_COLOUR])
        let attributedSubText = NSMutableAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_BOLD, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.PINK])
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        // Dismiss keyboard
        self.view.endEditing(true)
        
        self.signIn(onSuccess: {
            // Call the configureIntialViewController function in appdelegate to navigate to appropriate screen - in this case it would be the channels screen
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        ProgressHUD.show("Loading...")
        
        Api.User.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss() // Dismiss loading wheel on completion
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
        
    }
    
    // Enable/activate next button
    func enableLoginButton() {
        loginButton.setTitle("Log in", for: UIControl.State.normal)
        loginButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        loginButton.backgroundColor = BrandColours.PINK
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        loginButton.setTitleColor(.white, for: UIControl.State.normal)
        loginButton.isEnabled = true
    }
    
    // Disable next button
    func disabledLoginButton() {
        loginButton.setTitle("Log in", for: UIControl.State.normal)
        loginButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        loginButton.backgroundColor = BrandColours.DISABLED_BUTTON_PINK
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        loginButton.setTitleColor(.white, for: UIControl.State.normal)
        loginButton.isEnabled = false
    }
    
}
