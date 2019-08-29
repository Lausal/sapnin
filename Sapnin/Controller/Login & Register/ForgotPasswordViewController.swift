//
//  ForgotPasswordViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 29/06/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reset your password"
        
        setupUI()
    }
    
    func setupUI() {
        // Set focus on field upon load
        emailTextField.becomeFirstResponder()
        
        // Disable reset button by default
        disabledResetButton()
        
        // Add listener to text field to be able to enable/disable next button
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        setupEmailTextField()
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = emailTextField.text, !textFieldText.isEmpty else {
            // Disable
            disabledResetButton()
            return
        }
        // Enable
        enableResetButton()
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
    
    // Enable/activate next button
    func enableResetButton() {
        resetPasswordButton.setTitle("Reset password", for: UIControl.State.normal)
        resetPasswordButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        resetPasswordButton.backgroundColor = BrandColours.PINK
        resetPasswordButton.layer.cornerRadius = 25
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitleColor(.white, for: UIControl.State.normal)
        resetPasswordButton.isEnabled = true
    }
    
    // Disable next button
    func disabledResetButton() {
        resetPasswordButton.setTitle("Reset password", for: UIControl.State.normal)
        resetPasswordButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        resetPasswordButton.backgroundColor = BrandColours.DISABLED_BUTTON_PINK
        resetPasswordButton.layer.cornerRadius = 25
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitleColor(.white, for: UIControl.State.normal)
        resetPasswordButton.isEnabled = false
    }
    
    @IBAction func resetPasswordButtonDidTapped(_ sender: Any) {
        Api.User.resetPassword(email: emailTextField.text!, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess("We have sent instructions to your registered email to reset your password")
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}
