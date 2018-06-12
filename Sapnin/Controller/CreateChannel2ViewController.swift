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

class CreateChannel2ViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        Api.channel.createChannel(channelName: channelName!) {
            SVProgressHUD.dismiss()
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
        
        // Generate an ID for each contact
        var contactId = 0
        
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
                
                // If given name and phone number is not empty, then add to array
                if !givenName.isEmpty && !phoneNumber.isEmpty {
                    let contactToAppend = ContactsModel(contactId: String(contactId), givenName: givenName, familyName: familyName, phoneNumber: phoneNumber)
                    self.contacts.append(contactToAppend)
                } else {
                    return
                }
                
                contactId += 1
                
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        onSuccess()
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

extension CreateChannel2ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addParticipantsCell") as! AddParticipantsTableViewCell
        cell.tickIcon.isHidden = true
        
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
            
            let phoneNumber = convertNumber(number: contactToDisplay.phoneNumber!)
            cell.numberLabel.text = phoneNumber
            
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

        // Show tick icon on select, up to a maximum of 4 participants
        if participantCount <= 3 {
            let cell: AddParticipantsTableViewCell = tableView.cellForRow(at: indexPath)! as! AddParticipantsTableViewCell
            
            cell.tickIcon.isHidden = false
            
            // Store the ID of contact that was selected so we can use it on "cellForRowAt" to maintain the tick icon position upon search
            let selectedContact = sortedSections[indexPath.section][indexPath.row]
            selectedContactId.append(selectedContact.contactId)
            
            // Add 1 to participant count
            participantCount += 1
            participantCountLabel.text = String(describing: participantCount) + " / 4"
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        let cell: AddParticipantsTableViewCell = tableView.cellForRow(at: indexPath)! as! AddParticipantsTableViewCell
        
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
        

    }
    
}

extension CreateChannel2ViewController: UISearchBarDelegate {
    
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
