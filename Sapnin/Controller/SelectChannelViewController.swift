//
//  SelectChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import ProgressHUD

class SelectChannelViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var activity: String!
    var emoji: String!
    var channelList = [Channel]()
    var selectedChannelList = [Channel]()
    var sendButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        observeChannels()
    }
    
    func setupNavigationBar() {
        title = "Select channel"
        
        // Add send button to top right of header - disabled by default
        sendButton = UIBarButtonItem(title: "Send", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.sendButtonDidTapped))
        sendButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = sendButton
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
    
    // Get all of the users corresponding channels from Firebase
    func observeChannels() {
        
        Api.UserChannel.getUserChannels(uid: Api.User.currentUserId) { (channel) in
            
            // Check and make sure channel object is not already added into the channelList (i.e. duplication) by checking if channelID already exists in the array
            if !self.channelList.contains(where: {$0.channelId == channel.channelId}) {
                // If not duplicate, then append to channelList array
                self.channelList.append(channel)
                
                // Sort channels by date
                self.sortChannels()
            }
            
        }
    }
    
    // Sort channels by date order, so latest channel is at the top
    func sortChannels() {
        
        channelList = channelList.sorted(by: {$0.lastMessageDate > $1.lastMessageDate})
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Send push notification to users of the selected channels
    @objc func sendButtonDidTapped() {
        
        ProgressHUD.show("Loading...")
        
        // Get all the userID's of each channel and combine into single array (userIDList)
        var userIDList = [String]()
        for channel in self.selectedChannelList {
            userIDList = userIDList + channel.users!
        }
        
        // Remove duplicate user ID's so we don't send the same push notification twice
        userIDList = userIDList.unique()
        
        /*** Send push notification to each user of selected channels - remove duplicate users ***/
        
        // Get current user object to be used as from user
        Api.User.observeSpecificUserById(uid: Api.User.currentUserId, onSuccess: { (currentUser) in
            
            // Now loop through and grab each of the user information in the group based on their ID's so we can get the token and send push accordingly
            for userId in userIDList {
                // Get the user information by passing userID
                Api.User.observeSpecificUserById(uid: userId, onSuccess: { (user) in
                    // If the user has a tokenID (I.e. push turned on), then send push notification
                    if user.tokenID != nil {
                        
                        sendBroadcastPushNotifications(emoji: self.emoji, activity: self.activity, fromUser: currentUser, toUser: user, badge: 1)
                    }
                })
            }
        })
        
        ProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }

}

extension SelectChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pass the channel object to the cell class to display information
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectChannelTableViewCell") as! SelectChannelTableViewCell
        let channel = self.channelList[indexPath.row]
        cell.loadData(channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set radio button to selected style
        let cell = tableView.cellForRow(at: indexPath)! as! SelectChannelTableViewCell
        cell.radioButton.image = (UIImage(named: "selected_radio_icon"))
        
        let channel: Channel
        channel = channelList[indexPath.row]
        
        // Add selected channel object to selectedChannelList
        selectedChannelList.append(channel)
        
        // Enable send button
        sendButton?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // Set radio button to selected style
        let cell = tableView.cellForRow(at: indexPath)! as! SelectChannelTableViewCell
        cell.radioButton.image = (UIImage(named: "deselected_radio_icon"))
        
        let channel: Channel
        channel = channelList[indexPath.row]
        
        // Get the channel deselected and remove them from the selectedChannelList array by finding the index of the channel object in the selectedChannelList array - this is done by finding matching channelId's between the channel deselected, and the corresponding object in selectedChannelList array
        if let index = selectedChannelList.firstIndex(where: { $0.channelId == channel.channelId }) {
            selectedChannelList.remove(at: index)
        }
        
        // Set send button to disabled if no channels are selected
        if selectedChannelList.count == 0 {
            sendButton?.isEnabled = false
        }
    }
    
}

extension SelectChannelViewController: UISearchBarDelegate {
    
}
