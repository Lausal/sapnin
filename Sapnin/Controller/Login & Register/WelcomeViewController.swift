//
//  ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 25/03/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var loginWithEmailButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var name: String?
    var email: String?
    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // Setting status bar colour to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupUI() {
        setupSignUpButton()
    }
    
    // Configure sign up button
    func setupSignUpButton() {
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_REGULAR, size: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
        let attributedSubText = NSMutableAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.font : UIFont(name: ROBOTO_BOLD, size: 12), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    // Facebook login button tap event - Handles FB authentication
    @IBAction func loginWithFacebookButtonDidTapped(_ sender: Any) {
        
        // Login manager provides methods for logging in and out of FB
        let fbLoginManager = LoginManager()
        
        // Specify which permissions/data we want to ask for from FB - and then grab the user credentials if permitted
        fbLoginManager.logIn(permissions: ["public_profile", "email"], viewController: self) { (result) in
            
            switch result {
            case .success(granted: _, declined: _, token: _):
                print ("Login success to Facebook")
                self.signIntoFacebookFirebase()
                break
            case .failed(let error):
                ProgressHUD.showError("Login failed")
                print(error)
                break
            case .cancelled:
                print("Cancelled")
                break
            }
            
        }
    }
    
    // Sign into Firebase using FaceBook credentials
    func signIntoFacebookFirebase() {
        ProgressHUD.show("Loading...")
        
        // Create credentials used for Firebase using the retrieved Facebook data
        guard let authenticationToken = AccessToken.current?.tokenString else {
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        
        // Sign in and retrieve FB data, then push the data to Firebase
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            
            // Create a dictionary from the information retrieved from FB and push retrieved FB data to Firebase (Authdata contains the FB user information)
            if let authData = result {
                
                // Create a dictionary from the user data gathered from FB
                let dict: Dictionary<String,Any> = [
                    "uid": authData.user.uid,
                    "email": authData.user.email,
                    "name": authData.user.displayName,
                    // Photo may be nil so check first then assign if applicable
                    "profilePictureUrl": (authData.user.photoURL == nil) ? "" : authData.user.photoURL!.absoluteString + "?height=500",
                ]
                
                // Push to Firebase - UpdateChildValue will create a new entry in database if it doesn't exist already.
                Ref().databaseSpecificUserRef(uid: authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        
                        Api.User.observeSpecificUserById(uid: authData.user.uid) { (u) in
                            if u.phoneNumber != nil && u.phoneNumber.count != 0{
                                // Call the configureIntialViewController function in appdelegate to navigate to appropriate screen - in this case it would be the messages screen
                                (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                            }else{
                                ProgressHUD.dismiss()
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let phVC = sb.instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
                                phVC.userId = authData.user.uid
                                self.navigationController?.pushViewController(phVC, animated: true)
                            }
                        }
                    } else {
                        ProgressHUD.showError(error!.localizedDescription)
                    }
                })
                
            }
        }
    }
}

