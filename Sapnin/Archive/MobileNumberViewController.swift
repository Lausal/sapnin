////
////  MobileNumberViewController.swift
////  Sapnin
////
////  Created by Alan Lau on 15/05/2018.
////  Copyright © 2018 lau. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import SVProgressHUD
//
//class MobileNumberViewController: UIViewController {
//
//    @IBOutlet weak var dialCodeTextField: UITextField!
//    @IBOutlet weak var numberTextField: UITextField!
//
//    var pickerView : UIPickerView!
//    var countryName = [String]()
//    var dialCode = [String]()
//    var countryCode = [String]()
//    var selectedRow = Int()
//
//    override func viewDidLoad() {
//
//        // Focus number text field on load
//        self.numberTextField.becomeFirstResponder()
//
//        setupPicker()
//        getCountries()
//        super.viewDidLoad()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        // Select United Kingdom by default in picker
//        pickerView.selectRow(228, inComponent: 0, animated: true)
//    }
//
//    // Update the corresponding user on Firebase with the inputted number
//    @IBAction func confirmButton_TouchUpInside(_ sender: Any) {
//
//        SVProgressHUD.show(withStatus: "Loading...")
//
//        // Remove the country code initials
//        let dialCode = "+" + (dialCodeTextField.text?.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted))!
//
//        let number = dialCode + " " + numberTextField.text!
//
//        AuthService.updateUserMobileNumber(number: number, onSuccess: {
//            SVProgressHUD.dismiss()
//            // Navigate to CameraViewController
//            self.performSegue(withIdentifier: "cameraVC", sender: nil)
//        }) { (error) in
//            print(error)
//        }
//    }
//
//    // Read the CountryCodes JSON and store in array
//    func getCountries() {
//        let filePath: String = Bundle.main.path(forResource: "CountryCodes", ofType: "json") as String!
//        let JSONData = NSData(contentsOfFile: filePath) as NSData!
//        let countryJSON = JSON(data: JSONData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
//
//        let numberOfCountries = countryJSON["countries"].count
//        for i in 0...numberOfCountries {
//            guard let countryName = countryJSON["countries"][i]["name"].string else { return }
//            guard let dialCode = countryJSON["countries"][i]["dialCode"].string else { return }
//            guard let countryCode = countryJSON["countries"][i]["code"].string else { return }
//            self.countryName.append(countryName)
//            self.dialCode.append(dialCode)
//            self.countryCode.append(countryCode)
//        }
//
//    }
//
//    func setupPicker() {
//        // UIPickerView
//        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//        self.pickerView.backgroundColor = UIColor.white
//
//        // Add interaction to text field to show pickerView on tap
//        dialCodeTextField.inputView = self.pickerView
//
//        // ToolBar
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red:1.00, green:0.18, blue:0.53, alpha:1.0)
//        toolBar.backgroundColor = UIColor.white
//        toolBar.sizeToFit()
//
//        // Adding button toolBar
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MobileNumberViewController.doneButton_TouchUpInside))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MobileNumberViewController.cancelButton_TouchUpInside))
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        dialCodeTextField.inputAccessoryView = toolBar
//    }
//
//    @objc func doneButton_TouchUpInside() {
//        dialCodeTextField.resignFirstResponder()
//        dialCodeTextField.text = "\(countryCode[selectedRow]) \(dialCode[selectedRow])"
//    }
//
//    @objc func cancelButton_TouchUpInside() {
//        dialCodeTextField.resignFirstResponder()
//    }
//
//
//}
//
//extension MobileNumberViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return countryName.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return countryName[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedRow = row
//    }
//
//
//
//}
