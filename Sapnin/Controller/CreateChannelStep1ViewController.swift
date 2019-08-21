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
    
    // 2D array that holds each of the user objects per section - i.e. [["John", "Jake"], ["Kim", "Kirsty"]]
    var sortedUsersPerSections: [[User]] = [[]]
    
    // Contains the list of filtered users (When user starts searching)
    var filteredUserList: [User] = []
    
    // Boolean state if user is in search mode
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTestData()
        sortUserList()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // DELETE THIS AND GRAB REAL USERS FROM FIREBASE
    func addTestData() {
        let user1 = User(userId: "a", email: "abc@gmail.com", name: "John Smith")
        let user2 = User(userId: "b", email: "abcd@gmail.com", name: "Alan Lau")
        let user3 = User(userId: "SFCq7oiXViPq2mj04yiTESGI7uV2", email: "abcde@gmail.com", name: "Luke Dooley")
        let user4 = User(userId: "d", email: "abc@gmail.com", name: "James Bond")
        let user5 = User(userId: "e", email: "abc@gmail.com", name: "Cristiano Ronaldo")
        let user6 = User(userId: "f", email: "abcd@gmail.com", name: "Matthew Pon")
        let user7 = User(userId: "g", email: "abcde@gmail.com", name: "David Beckham")
        let user8 = User(userId: "h", email: "abc@gmail.com", name: "Aladdin Cray")
        let user9 = User(userId: "i", email: "abc@gmail.com", name: "Sarah Smith")
        let user10 = User(userId: "j", email: "abcd@gmail.com", name: "Jojo Fish")
        let user11 = User(userId: "k", email: "abcde@gmail.com", name: "Will Smith")
        let user12 = User(userId: "l", email: "abc@gmail.com", name: "Chris Tucker")
        let user13 = User(userId: "m", email: "abc@gmail.com", name: "Dwayne Johnson")
        let user14 = User(userId: "n", email: "abcd@gmail.com", name: "Rayan Mohammed")
        let user15 = User(userId: "o", email: "abcde@gmail.com", name: "Eden Hazard")
        let user16 = User(userId: "p", email: "abc@gmail.com", name: "Joffery Chan")
        
        userList.append(user1)
        userList.append(user2)
        userList.append(user3)
        userList.append(user4)
        userList.append(user5)
        userList.append(user6)
        userList.append(user7)
        userList.append(user8)
        userList.append(user9)
        userList.append(user10)
        userList.append(user11)
        userList.append(user12)
        userList.append(user13)
        userList.append(user14)
        userList.append(user15)
        userList.append(user16)
        
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
        } else {
            let user = sortedUsersPerSections[indexPath.section][indexPath.row]
            cell.loadData(user)
            setCellSelectionState(indexPath: indexPath, cell: cell, user: user)
        }
        
        return cell
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
