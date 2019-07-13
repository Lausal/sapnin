//
//  CreateChannelStep2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class CreateChannelStep1ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countLabel: UILabel!
    
    var userList = [User]()
    var selectedUserList = [User]()
    
    // Unique list of first letters for each user
    var sortedUsersFirstLetters: [String] = []
    
    // 2D array that holds each of the users per section - i.e. [["John", "Jake"], ["Kim", "Kirsty"]]
    var sortedUsersPerSections: [[User]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTestData()
        sortUserList()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // DELETE THIS AND GRAB REAL USERS FROM FIREBASE
    func addTestData() {
        let user1 = User(userId: "abc", email: "abc@gmail.com", name: "John Smith")
        let user2 = User(userId: "adbc", email: "abcd@gmail.com", name: "Alan Lau")
        let user3 = User(userId: "abcde", email: "abcde@gmail.com", name: "Luke Dooley")
        userList.append(user1)
        userList.append(user2)
        userList.append(user3)
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
        searchBar.delegate = self
    }
    
    func setupNavigationBar() {
        title = "Add participants"
        
        // Add next button to top right of header
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nextButtonDidTapped))
        self.navigationItem.rightBarButtonItem = nextButton
        
        // Add cancel button to top left of header
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelButtonDidTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // Revert back to channel VC when cancel is tapped
    @objc func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonDidTapped() {
        self.performSegue(withIdentifier: "createChannelStep2VC", sender: nil)
    }

}

extension CreateChannelStep1ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedUsersPerSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pass the user object to the cell class to display the information
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChannelStep1TableViewCell") as! CreateChannelStep1TableViewCell
        cell.selectionStyle = .none
        
        let user = sortedUsersPerSections[indexPath.section][indexPath.row]
        cell.loadData(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // On select of row, set radio button to selected style and add the user to selectedUserList array whilst updating the participant count
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set radio button to selected style
        let cell = tableView.cellForRow(at: indexPath)! as! CreateChannelStep1TableViewCell
        cell.radioButton.image = (UIImage(named: "selected_radio_icon"))
        
        // Add the user object to the selectedUserList array
        let user = sortedUsersPerSections[indexPath.section][indexPath.row]
        selectedUserList.append(user)
        
        // Set the participant count label based on the selectedUsers array count
        countLabel.text = "\(selectedUserList.count) / 100"
        
    }
    
    // On deselect of row, set radio button to unselected style and remove the user from selectedUserList array whilst updating the participant count
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Set radio button to deselected style
        let cell = tableView.cellForRow(at: indexPath)! as! CreateChannelStep1TableViewCell
        cell.radioButton.image = (UIImage(named: "unselected_radio_icon"))
        
        // Get the user object selected
        let user = userList[indexPath.row]
        
        // Remove the user object from the selectedUserList array by finding the index of the user object in the selectedUserList array - this is done by finding matching userId's between the user deselected, and the corresponding object in selectedUserList array
        if let index = selectedUserList.firstIndex(where: { $0.userId == user.userId }) {
            selectedUserList.remove(at: index)
        }
        
        // Set the participant count label based on the selectedUsers array count
        countLabel.text = "\(selectedUserList.count) / 100"
        
    }
    
    // Set title of each section to the first letter of each user
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedUsersFirstLetters[section]
//        if isSearching {
//            return "Search results"
//        } else {
//            return sortedFirstLetters[section]
//        }
    }
    
    // This is the right hand side alphabetical bar
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedUsersFirstLetters
    }
    
    // Number of sections is based on unique first letters
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedUsersFirstLetters.count
//        if isSearching {
//            return 1
//        } else {
//            return sortedFirstLetters.count
//        }
    }
    
}

extension CreateChannelStep1ViewController: UISearchBarDelegate {
    
}
