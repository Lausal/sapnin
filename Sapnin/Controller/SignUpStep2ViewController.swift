////
////  SignUpStep2ViewController.swift
////  Sapnin
////
////  Created by Alan Lau on 29/06/2019.
////  Copyright © 2019 lau. All rights reserved.
////
//
//import UIKit
//
//class SignUpStep2ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//    }
//
//    func setupUI() {
//        setupEmailTextField()
//        setupNextButton()
//    }
//
//    // Configure email text field
//    func setupEmailTextField() {
//        emailTextField.layer.borderWidth = 1
//        emailTextField.layer.borderColor = BrandColours.FIELD_BORDER_COLOUR.cgColor
//        emailTextField.backgroundColor = BrandColours.FIELD_BACKGROUND_COLOUR
//        emailTextField.layer.cornerRadius = 5
//        emailTextField.font = UIFont(name: "Roboto-Regular", size: 14)
//
//        // Set left and right padding of text field input
//        emailTextField.paddingLeft = 16
//        emailTextField.paddingRight = 16
//
//        // Set placeholder styling
//        let placeholderAttr = NSAttributedString(string: "Email address", attributes: [NSAttributedString.Key.foregroundColor : BrandColours.PLACEHOLDER_TEXT_COLOUR])
//        emailTextField.attributedPlaceholder = placeholderAttr
//
//        // Specify text colour
//        emailTextField.textColor = BrandColours.PINK
//    }
//
//    // Configure next button
//    func setupNextButton() {
//        nextButton.setTitle("Next", for: UIControl.State.normal)
//        nextButton.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
//        nextButton.backgroundColor = BrandColours.PINK
//        nextButton.layer.cornerRadius = 25
//        nextButton.clipsToBounds = true
//        nextButton.setTitleColor(.white, for: UIControl.State.normal)
//    }
//
//}
