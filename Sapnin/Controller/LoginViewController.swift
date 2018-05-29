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
import SVProgressHUD
import SwiftyJSON

class LoginViewController: UIViewController {
    
    var name: String?
    var email: String?
    var profilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // DELETE THIS
        AuthService.logout(onSuccess: {
            //
        }) { (error) in
            //
        }
        
        // If the user has not logged out, then automatically switch to the Home View Controller
        if Api.user.CURRENT_USER != nil {
            //self.performSegue(withIdentifier: "cameraVC", sender: nil)
        }
    }
    
    // Setting status bar colour to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginWithFacebook_TouchUpInside(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print ("Login success to Facebook")
                self.signIntoFirebase()
                break
            case .failed(let error):
                SVProgressHUD.showError(withStatus: "Login failed")
                print(error)
                break
            case .cancelled:
                print("Cancelled")
                break
            }
        }
    }
    
    func signIntoFirebase() {
        SVProgressHUD.show(withStatus: "Loading...")
        guard let authenticationToken = AccessToken.current?.authenticationToken else {
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print (error)
                return
            } else {
                print ("Login success to Firebase")
                self.fetchFacebookUserDetails()
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
            
            let dictionaryValues = ["name": self.name, "email": self.email, "profilePictureUrl": profilePictureUrl]
            
            let values = [uid: dictionaryValues]
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let error = error {
                    print(error)
                    return
                }
                print("Successfully saved user into Firebase database")
                
                SVProgressHUD.dismiss()
                
                // Navigate to MobileNumberViewController
                self.performSegue(withIdentifier: "mobileNumberVC", sender: nil)
            })
        }
    }
}

