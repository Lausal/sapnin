//
//  CreateChannel1ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 23/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import Contacts
import SVProgressHUD
import FirebaseDatabase
import FirebaseAuth
import PhoneNumberKit

class SelectParticipantsViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var participantCountLabel: UILabel!
    
    var selectedContactId = [String]()
    var contactStore = CNContactStore()
    var contacts = [ContactsModel]()
    var participantCount: Int = 0
    var sortedFirstLetters: [String] = []
    var sortedSections: [[ContactsModel]] = [[]]
    var filteredData: [ContactsModel] = []
    var isSearching = false
    var channelName: String? = nil
    
    var firstName = [String]()
    var lastName = [String]()
    var number = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable done button by default
        doneButton.isEnabled = false
        
        setupTableView()
        
        // Ask permission to access contacts
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Contacts authorisation success")
            }
        }
        
        fetchContacts {
            self.sortContactsList()
        }
    }
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loading...")
        
        // For Firebase purposes, we set each array as [ID: true] format
        var newSelectedContactId = [String: Bool]()
        for id in selectedContactId {
            newSelectedContactId[id] = true
        }
        
        Api.channel.createChannel(channelName: channelName!, users: newSelectedContactId) {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "channelsVC", sender: nil)
        }
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 60
        searchBar.delegate = self
        
        // Change search bar colour
        let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = ColourPalette.GREY
        
        // Change search bar font
        let font = UIFont(name: "Roboto-Light", size: 18)!
        searchBarTextField?.font = font
    }
    
    func fetchContacts(onSuccess: @escaping () -> Void) {
        // Key is the type of information we're fetching from contacts
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
                
                // Grab information from contacts result
                let givenName = contact.givenName
                let familyName = contact.familyName
                
                // Grab first number, if no number is associated then mark as blank
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
                
                // Set isUserRegistered attribute based on if contact exists so we can use this for to identify which cell identifier we need to show
                Api.User.checkIfContactExists(number: phoneNumber, contactExists: { (contactExists, contactUserId) in
                    if contactExists == true {
                        // If given name and phone number is not empty, then add to array
                        if !givenName.isEmpty && !phoneNumber.isEmpty {
                            let contactToAppend = ContactsModel(contactId: contactUserId!, givenName: givenName, familyName: familyName, phoneNumber: phoneNumber, isUserRegistered: true)
                            self.contacts.append(contactToAppend)
                        } else {
                            return
                        }
                    } else {
                        // If given name and phone number is not empty, then add to array
                        if !givenName.isEmpty && !phoneNumber.isEmpty {
                            let contactToAppend = ContactsModel(contactId: nil, givenName: givenName, familyName: familyName, phoneNumber: phoneNumber, isUserRegistered: false)
                            self.contacts.append(contactToAppend)
                        } else {
                            return
                        }
                    }
                    
                    onSuccess()
                    self.tableView.reloadData()
                })
            }
        } catch {
            print(error)
        }
    }
    
    // Converts phone number to it's international format (UK only for now)
    func convertNumber(number: String) -> String? {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phoneNumber = try phoneNumberKit.parse(number, withRegion: "GB", ignoreType: true)
            return "+" + String(phoneNumber.countryCode) + " " + String(phoneNumber.nationalNumber)
        }
        catch {
            print("Generic parser error")
            return nil
        }
    }
    
    func sortContactsList() {
        // Get the first letter of every contact, remove duplicates and then sort alphabetically
        let firstLetters = contacts.map { $0.titleFirstLetter }
        let uniqueFirstLetters = Array(Set(firstLetters))
        sortedFirstLetters = uniqueFirstLetters.sorted()
        
        // Group contacts object into an array of arrays based on first letter i.e. [["John", "Jake"], ["Kim", "Kirsty"]]
        sortedSections = sortedFirstLetters.map { firstLetter in
            return contacts
                .filter { $0.titleFirstLetter == firstLetter }
                .sorted { $0.givenName < $1.givenName }
        }
        
        // Reload tableview to get the index on right hand side to show
        tableView.reloadData()
    }
}

extension SelectParticipantsViewController: SelectParticipantsTableViewCellDelegate {
    func inviteContact() {
        // Text to share
        let text = "Download Sapnin now lorem ipsum dolor sit amet"
        
        // UIActivityViewController is the iOS sharing pop up functionality
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension SelectParticipantsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return "Search results"
        } else {
            return sortedFirstLetters[section]
        }
    }
    
    // This is the right hand side slider
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedFirstLetters
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return sortedFirstLetters.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredData.count
        } else {
            return sortedSections[section].count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contactToDisplay = sortedSections[indexPath.section][indexPath.row]
        let isUserRegistered = contactToDisplay.isUserRegistered
        
        var cellIdentifier = ""
        
        if (isUserRegistered == true) {
            cellIdentifier = "addParticipantsCell"
        } else {
            cellIdentifier = "inviteParticipantsCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SelectParticipantsTableViewCell
        cell.delegate = self
        
        if isSearching {
            let contactToDisplay = filteredData[indexPath.row]
            cell.nameLabel.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
            cell.numberLabel.text = contactToDisplay.phoneNumber
            
            // Display tick if row is already selected (Select contact ID's stored in "selectedContactId" array, otherwise don't display tick
            for contactId in selectedContactId {
                if contactToDisplay.contactId == contactId {
                    cell.tickIcon.isHidden = false
                }
            }
            
        } else {
            let contactToDisplay = sortedSections[indexPath.section][indexPath.row]
            cell.nameLabel.text = contactToDisplay.givenName + " " + contactToDisplay.familyName
            cell.numberLabel.text = contactToDisplay.phoneNumber
            
            for contactId in selectedContactId {
                if contactToDisplay.contactId == contactId {
                    print(contactToDisplay.givenName)
                    cell.tickIcon.isHidden = false
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Tag "2" represents the "addParticipantsCell" identifier - only perform below action for corresponding cell
        let cell: SelectParticipantsTableViewCell = tableView.cellForRow(at: indexPath)! as! SelectParticipantsTableViewCell
        if cell.tag == 2 {
            // Enable done button
            doneButton.isEnabled = true
            
            // Show tick icon on select, up to a maximum of 4 participants
            if participantCount <= 3 {
                let cell: SelectParticipantsTableViewCell = tableView.cellForRow(at: indexPath)! as! SelectParticipantsTableViewCell
                
                cell.tickIcon.isHidden = false
                
                // Store the ID of contact that was selected so we can use it on "cellForRowAt" to maintain the tick icon position upon search
                let selectedContact = sortedSections[indexPath.section][indexPath.row]
                selectedContactId.append(selectedContact.contactId!)
                
                // Add 1 to participant count
                participantCount += 1
                participantCountLabel.text = String(describing: participantCount) + " / 4"
            }

        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Tag "2" represents the "addParticipantsCell" identifier - only perform below action for corresponding cell
        let cell: SelectParticipantsTableViewCell = tableView.cellForRow(at: indexPath)! as! SelectParticipantsTableViewCell
        if cell.tag == 2 {
            cell.tickIcon.isHidden = true
            let selectedContact = sortedSections[indexPath.section][indexPath.row]
            
            // Remove ID from selectedContactId when deselect
            for (index, contactId) in selectedContactId.enumerated() {
                if selectedContact.contactId == contactId {
                    selectedContactId.remove(at: index)
                }
            }
            
            // Deduct 1 to participant count
            participantCount -= 1
            participantCountLabel.text = String(describing: participantCount) + " / 4"
            
            // If no participants are selected, then disable done button
            if participantCount == 0 {
                doneButton.isEnabled = false
            }
        }
    }
}

extension SelectParticipantsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If search bar is empty, then hide keyboard, otherwise filter data
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = contacts.filter({ (contact) -> Bool in
                guard let text = searchBar.text else { return false }
                return contact.givenName.lowercased().contains(text.lowercased())
            })
            tableView.reloadData()
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}
