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
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD
import SwiftyJSON

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
    
    // Facebook login button tap event
    @IBAction func loginWithFacebookButtonDidTapped(_ sender: Any) {
        let loginManager = LoginManager()
        // Grab user profile and email address from Facebook
        loginManager.logIn([.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print ("Login success to Facebook")
                self.signIntoFirebase()
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
    
    func signIntoFirebase() {
        ProgressHUD.show("Loading...")
        guard let authenticationToken = AccessToken.current?.authenticationToken else {
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print (error)
                return
            } else {
                // Check if user already exists, Firebase uses the same ID for authenticated user when signing in. If they do then no need to fetch Facebook details and just go directly to channels view
                guard let userId = user?.uid else { return }
                Api.User.checkIfUserExists(userId: userId, userExists: { (userExists) in
                    if userExists == true {
                        ProgressHUD.dismiss()
                        // Call the configureIntialViewController function in appdelegate to navigate to appropriate screen - in this case it would be the channels screen
                        (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                    } else {
                        self.fetchFacebookUserDetails()
                    }
                })
                print ("Login success to Firebase")
            }
        }
    }
    
    func fetchFacebookUserDetails() {
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest) { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                guard let responseDictionary = response.dictionaryValue else {
                    return
                }
                // Extract the JSON information
                let json = JSON(responseDictionary)
                self.name = json["name"].string
                self.email = json["email"].string
                
                // Fetch profile image
                guard let profilePictureUrl = json["picture"]["data"]["url"].string else {
                    return
                }
                guard let url = URL(string: profilePictureUrl) else {
                    return
                }
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    self.profilePicture = UIImage(data: data)
                    self.saveUserIntoFirebase()
                }).resume()
                break
                
            case .failed(let error):
                print(error)
                break
            }
        }
        graphRequestConnection.start()
    }
    
    // Store profile picture onto Firebase Storage, and then create a user database entity to store the user information
    func saveUserIntoFirebase() {
        
        // Grab profile picture, and store on Firebase Storage
        let fileName = UUID().uuidString
        guard let profilePicture = self.profilePicture else {
            return
        }
        guard let uploadData = UIImageJPEGRepresentation(profilePicture, 0.3) else {
            return
        }
        Storage.storage().reference().child("profilePictures").child(fileName).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved profile picture to Firebase storage")
            
            // After storing on Firebase storage, get the URL String of storage location
            guard let profilePictureUrl = metadata?.downloadURL()?.absoluteString else {
                return
            }
            
            // Then add user details to Firebase database
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            // Database reference of the new user
            let newUserRef = Ref().databaseUserTableRef.child(uid)
            
            let dict = ["uid": uid, "name": self.name, "email": self.email, "profilePictureUrl": profilePictureUrl]
            
            newUserRef.setValue(dict) { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                } else {
                    ProgressHUD.dismiss()
                    // Call the configureIntialViewController function in appdelegate to navigate to appropriate screen - in this case it would be the channels screen
                    (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                }
            }
            
        }
    }
}

