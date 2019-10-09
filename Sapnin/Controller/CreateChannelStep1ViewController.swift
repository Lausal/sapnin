//
//  CreateChannelStep2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI
import SVProgressHUD


class CreateChannelStep1ViewController: UIViewController,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countLabel: UILabel!
    
    var userList = [User]()
    var selectedUserList = [User]()
    
    //Numbers that have not app installed
    var numbersWithoutApp = [String]()
    
    // Unique list of first letters for each user
    var sortedUsersFirstLetters: [String] = []
    
    // 2D array that holds each of the user objects per section - i.e. [["John", "Jake"], ["Kim", "Kirsty"]]
    var sortedUsersPerSections: [[User]] = [[]]
    
    // Contains the list of filtered users (When user starts searching)
    var filteredUserList: [User] = []
    
    // Boolean state if user is in search mode
    var isSearching = false
    
    enum ContactsFilter {
        case none
        case mail
        case message
    }
    
//    var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    var filter: ContactsFilter = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContacts()
        
        setupTableView()
        setupNavigationBar()
    }
    
    fileprivate func loadContacts() {
        
        let contacts = PhoneContacts.getContacts()
        if contacts.count == 0{
            return
        }
        
        SVProgressHUD.show()
        for i in 0...contacts.count-1 {
            let contact = contacts[i]
                //Check if this Number has the App,
                Api.User.checkUserExistense(phoneNumber: contact.phoneNumbers.first!.value.stringValue) { (user) in
                    
                    var userName = ""
                    if (contact.familyName + contact.givenName).replacingOccurrences(of: " ", with: "").count == 0{
                        
                        if contact.organizationName.count == 0{
                            userName = contact.organizationName
                        }else{
                            userName = contact.phoneNumbers.count > 0 ? contact.phoneNumbers.first!.value.stringValue : "No Name"
                        }
                    }else{
                        userName = contact.givenName + " " + contact.familyName
                    }
                    
                    if user != nil{
                        
                       self.userList.append(User(userId: user!.userId, email: contact.emailAddresses.count > 0 ? contact.emailAddresses.first!.value as String : "", name: user!.name,phoneNumber: contact.phoneNumbers.count > 0 ? contact.phoneNumbers.first!.value.stringValue : ""))
                        self.numbersWithoutApp.append(contact.phoneNumbers.first!.value.stringValue)
                        
                    }else{
                        
                        self.userList.append(User(userId: contact.phoneNumbers.count > 0 ? contact.phoneNumbers.first!.value.stringValue : "", email: contact.emailAddresses.count > 0 ? contact.emailAddresses.first!.value as String : "", name: userName,phoneNumber: contact.phoneNumbers.count > 0 ? contact.phoneNumbers.first!.value.stringValue : ""))
                    }
                    
                    if i == contacts.count - 1{
                        SVProgressHUD.dismiss()
                        self.sortUserList()
                    }
            }
        }
    }

    // Sort the user list alphabetically and into a 2D array so same letter first names are grouped together
    func sortUserList() {
        // Get the first letter of each user, remove duplicates and then sort alphabetically
        let firstLetters = userList.map { $0.getFirstLetterOfName }
        let uniqueFirstLetters = Array(Set(firstLetters))
        sortedUsersFirstLetters = uniqueFirstLetters.sorted()
        
        // Group user object into an array of arrays (2D array) based on first letter i.e. [["John", "Jake"], ["Kim", "Kirsty"]]
        sortedUsersPerSections = sortedUsersFirstLetters.map { firstLetter in
            return userList
                .filter { $0.getFirstLetterOfName == firstLetter }
                .sorted { $0.name < $1.name }
        }
        
        // Reload tableview to get the index on right hand side to show
        tableView.reloadData()
    }
    
    // Tableview styling
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.sectionIndexColor = BrandColours.PINK
        searchBar.delegate = self
    }
    
    func setupNavigationBar() {
        title = "Add participants"
        
        // Add next button to top right of header
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.nextButtonDidTapped))
        self.navigationItem.rightBarButtonItem = nextButton
        
        // Add cancel button to top left of header
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButtonDidTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // Revert back to channel VC when cancel is tapped
    @objc func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // Go to step 2
    @objc func nextButtonDidTapped() {
        self.performSegue(withIdentifier: "createChannelStep2VC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send selected user list to step 2
        if segue.identifier == "createChannelStep2VC" {
            let controller = segue.destination as! CreateChannelStep2ViewController
            controller.selectedUserList = selectedUserList
        }
    }

}

extension CreateChannelStep1ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows per section - the number of rows depends on whether the user is searching or not
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredUserList.count
        } else {
            return sortedUsersPerSections[section].count
        }
    }
    
    // Configure the cells depending on if the user is in search mode or not
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChannelStep1TableViewCell") as! CreateChannelStep1TableViewCell
        
        // Pass the user object to the cell class to display the information - use the filteredUsers array list if the user is searching, otherwise use the sortedUsersPerSections array list
        if isSearching && filteredUserList.count != 0 {
            let user = filteredUserList[indexPath.row]
            cell.loadData(user)
            setCellSelectionState(indexPath: indexPath, cell: cell, user: user)
            setInviteButtonVisibility(indexPath: indexPath, cell: cell, user: user)
        } else {
            let user = sortedUsersPerSections[indexPath.section][indexPath.row]
            cell.loadData(user)
            setCellSelectionState(indexPath: indexPath, cell: cell, user: user)
            setInviteButtonVisibility(indexPath: indexPath, cell: cell, user: user)
        }
        
        cell.inviteButton.tag = indexPath.row
        cell.inviteButton.accessibilityHint = "\(indexPath.section)"
        cell.inviteButton.addTarget(self, action: #selector(sendMessages(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func sendMessages(sender:UIButton) {
        var user : User!
        if isSearching && filteredUserList.count != 0 {
            user = filteredUserList[sender.tag]
        }else{
            user = sortedUsersPerSections[Int(sender.accessibilityHint!)!][sender.tag]
        }
        if MFMessageComposeViewController.canSendText() == true {
            let recipients:[String] = [user.phoneNumber]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self
            messageController.recipients = recipients
            messageController.body = "Hey checkout this app..."
            self.present(messageController, animated: true, completion: nil)
        } else {
            //handle text messaging not available
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func setInviteButtonVisibility(indexPath: IndexPath, cell: CreateChannelStep1TableViewCell, user: User) {
        // User/cell is selected
        if numbersWithoutApp.contains(where:{ $0 == user.phoneNumber }) {
            cell.inviteButton.isHidden = true
        } else {
            cell.inviteButton.isHidden = false
        }
    }
    
    
    // When filtering, the radio button and cell selection state doesn't match as we're using different arrays for the filtered users list. So we need to call this function to compare if the corresponding cell is selected or not by checking if the userId is in the selectedUserList.
    func setCellSelectionState(indexPath: IndexPath, cell: CreateChannelStep1TableViewCell, user: User) {
        // User/cell is selected
        if selectedUserList.contains(where:{ $0.userId == user.userId }) {
            cell.isSelected = true
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.radioButton.image = UIImage(named: "selected_radio_icon")
        } else {
            // User/cell is not selected
            cell.isSelected = false
            tableView.deselectRow(at: indexPath, animated: true)
            cell.radioButton.image = UIImage(named: "deselected_radio_icon")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // On select of row, set radio button to selected style and add the user to selectedUserList array whilst updating the participant count
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set radio button to selected style
        let cell = tableView.cellForRow(at: indexPath)! as! CreateChannelStep1TableViewCell
        cell.radioButton.image = (UIImage(named: "selected_radio_icon"))
        
        let user: User
        
        // Get the selected user object and add to the selectedUserList array. The user object will be retrieved from different arrays depending if user is searching or not
        if isSearching && filteredUserList.count != 0 {
            user = filteredUserList[indexPath.row]
        } else {
            user = sortedUsersPerSections[indexPath.section][indexPath.row]
        }
        selectedUserList.append(user)
        
        // Update the participant count label based on the selectedUsers array count
        countLabel.text = "\(selectedUserList.count) / 100"
        
    }
    
    // On deselect of row, set radio button to unselected style and remove the user from selectedUserList array whilst updating the participant count
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Set radio button to deselected style
        let cell = tableView.cellForRow(at: indexPath)! as! CreateChannelStep1TableViewCell
        cell.radioButton.image = (UIImage(named: "deselected_radio_icon"))
        
        let user: User
        
        // Get the user deselected and remove them from the selectedUserList array by finding the index of the user object in the selectedUserList array - this is done by finding matching userId's between the user deselected, and the corresponding object in selectedUserList array
        if isSearching && filteredUserList.count != 0 {
            user = filteredUserList[indexPath.row]
        } else {
            user = sortedUsersPerSections[indexPath.section][indexPath.row]
        }
        if let index = selectedUserList.firstIndex(where: { $0.userId == user.userId }) {
            selectedUserList.remove(at: index)
        }
        
        // Update the participant count label based on the selectedUsers array count
        countLabel.text = "\(selectedUserList.count) / 100"
        
    }
    
    // Set title of each section to the first letter of each user. If the user is searching, then set the section title to "Search results"
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return "Search results"
        } else {
            return sortedUsersFirstLetters[section]
        }
    }
    
    // This is the right hand side alphabetical bar
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedUsersFirstLetters
    }
    
    // Number of sections is based on unique first letters. If the user is searching, then there's just 1 section
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return sortedUsersFirstLetters.count
        }
    }
    
}

extension CreateChannelStep1ViewController: UISearchBarDelegate {
    
    // Called when text on search bar is changed - filter the results automatically as the user types
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filteredUserList = userList.filter({ (user) -> Bool in
                guard let text = searchBar.text else { return false }
                return user.name.lowercased().contains(text.lowercased())
            })
            print(filteredUserList.count)
            tableView.reloadData()
        }
    }
    
}
