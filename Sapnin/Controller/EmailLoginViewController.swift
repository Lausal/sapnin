//
//  EmailLoginViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 27/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class EmailLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUpButton()
    }
    
    // Configure email text field
    func setupEmailTextField() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
        emailTextField.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
        emailTextField.layer.cornerRadius = 5
        emailTextField.font = UIFont(name: "Roboto-Regular", size: 14)
        
        // Set left and right padding of text field input
        emailTextField.paddingLeft = 16
        emailTextField.paddingRight = 16
        
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
        passwordTextField.paddingLeft = 16
        passwordTextField.paddingRight = 16
        
        // Set placeholder styling
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
        passwordTextField.attributedPlaceholder = placeholderAttr
        
        // Specify text colour
        passwordTextField.textColor = BrandColours.PINK
    }
    
    // Configure login button
    func setupLoginButton() {
        loginButton.setTitle("Log in", for: UIControl.State.normal)
        loginButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        loginButton.backgroundColor = BrandColours.PINK
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        loginButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    // Configure sign up button
    func setupSignUpButton() {
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_REGULAR, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.TEXT_COLOUR])
        let attributedSubText = NSMutableAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_BOLD, size: 12), NSAttributedString.Key.foregroundColor: BrandColours.PINK])
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
}
