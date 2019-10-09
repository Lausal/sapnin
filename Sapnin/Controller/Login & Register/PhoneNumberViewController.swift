//
//  PhoneNumberViewController.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 14/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    var name: String!
    var email: String!
    var userId : String!
    var userCountryCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Enter phone number"
        
        if userId != nil{
            btnNext.setTitle("Get Started", for: .normal)
        }
        
        // Set focus on field upon load
        txtPhoneNumber.becomeFirstResponder()
        
        // Disable next button by default
        disabledNextButton()
        
        // Add listener to text field to be able to enable/disable next button
        txtPhoneNumber.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        // Style name text field
        Utility().styleTextField(textfield: txtPhoneNumber, text: "Phone number")
        
        //Get Country Code and set
        getLocaleCountryCode()
    }
    
    
    //Get country code of user and set it in text field.
    @objc func getLocaleCountryCode(){
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            userCountryCode = countryPhoneCodes[countryCode] == nil ? "" : countryPhoneCodes[countryCode]!
            let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 48))
            let lblCountryCode = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 48))
            lblCountryCode.text = countryPhoneCodes[countryCode]
            lblCountryCode.textAlignment = .center
            lblCountryCode.textColor = .gray
            leftView.addSubview(lblCountryCode)
//            txtPhoneNumber.leftViewMode = .always
            txtPhoneNumber.leftView = leftView
        }
        
    }
    
    // Enable next button if text field is filled, otherwise disable
    @objc func textFieldDidChange() {
        guard let textFieldText = txtPhoneNumber.text, !textFieldText.isEmpty else {
            // Disable
            disabledNextButton()
            return
        }
        // Enable
        enableNextButton()
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        if userId != nil{
            
            let dict: Dictionary<String,Any> = [
                "phoneNumber": userCountryCode + txtPhoneNumber.text!
            ]
            
            Ref().databaseSpecificUserRef(uid: userId).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                if error == nil {
                    let channelStoryboard = UIStoryboard(name: "Channel", bundle: nil)
                    let initialVC = channelStoryboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)

                    UIApplication.shared.delegate?.window??.rootViewController = initialVC
                }
            })
        }else{
            self.performSegue(withIdentifier: "signupVC", sender: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupVC" {
            let controller = segue.destination as! SignUpStep3ViewController
            controller.name = self.name
            controller.email = self.email
            controller.phoneNumber = userCountryCode + txtPhoneNumber.text!
        }
    }
    
    // Enable/activate next button
    func enableNextButton() {
        
        if userId == nil{
            btnNext.setTitle("Next", for: UIControl.State.normal)
        }else{
            btnNext.setTitle("Get Started", for: UIControl.State.normal)
        }
        
        btnNext.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        btnNext.backgroundColor = BrandColours.PINK
        btnNext.layer.cornerRadius = 25
        btnNext.clipsToBounds = true
        btnNext.setTitleColor(.white, for: UIControl.State.normal)
        btnNext.isEnabled = true
    }
    
    // Disable next button
    func disabledNextButton() {
        if userId == nil{
            btnNext.setTitle("Next", for: UIControl.State.normal)
        }else{
            btnNext.setTitle("Get Started", for: UIControl.State.normal)
        }
        btnNext.titleLabel?.font = UIFont(name: ROBOTO_REGULAR, size: 18)
        btnNext.backgroundColor = BrandColours.DISABLED_BUTTON_PINK
        btnNext.layer.cornerRadius = 25
        btnNext.clipsToBounds = true
        btnNext.setTitleColor(.white, for: UIControl.State.normal)
        btnNext.isEnabled = false
    }
    

}
