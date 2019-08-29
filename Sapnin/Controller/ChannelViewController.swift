//
//  ChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 21/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var channelList = [Channel]()
    var profilePicture: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    // This is for the search bar, specifying nil means the search results will appear on the same/current page
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBarController()
        observeChannels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Register user to push notifications - the topic basically acts as a key, so if user B want to send a notification to user A, then they can use the topic which in this case is the user ID
        if !Api.User.currentUserId.isEmpty {
            Messaging.messaging().subscribe(toTopic: Api.User.currentUserId)
        }
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
    
    // Tableview styling
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
    }
    
    // Function to make search bar appear and its settings
    func setupSearchBarController() {
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = UIColor.white
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Channels"
        
        // Set large navigation bar style
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set navigation bar colour to pink
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: BrandColours.PINK]
        
        // Add new group button to top right of header
        let newGroupButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newGroupButtonDidTapped))
        self.navigationItem.rightBarButtonItem = newGroupButton
        
        // Style and create container to hold avatar on header
        let avatarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = 16
        profilePicture.clipsToBounds = true
        profilePicture.isUserInteractionEnabled = true
        avatarContainerView.addSubview(profilePicture)
        
        // Add tap gesture to avatar image
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarButtonDidTapped))
        profilePicture.addGestureRecognizer(tapGesture)
        
        // Add avatar button/image to left bar button on header
        let avatarButton = UIBarButtonItem(customView: avatarContainerView)
        self.navigationItem.leftBarButtonItem = avatarButton
        
        // Load user avatar image if available, otherwise use the no profile icon. This will update in real time for any changes as we use the observe functionality
        Api.User.observeSpecificUserById(uid: Api.User.currentUserId) { (user) in
            if user.profilePictureUrl != nil {
                let profilePictureUrl = URL(string: user.profilePictureUrl!)
                self.profilePicture.loadImage(profilePictureUrl!.absoluteString)
            } else {
                self.profilePicture.image = UIImage(named: "no_profile_icon")
            }
        }
    }
    
    // Switch to CreateGroupVC when new group button is tapped
    @objc func newGroupButtonDidTapped() {
        
        // TEST DELETE
        Api.User.observeSpecificUserById(uid: Api.User.currentUserId) { (fromUser) in
            print(fromUser.name)
            Api.User.observeSpecificUserById(uid: "iS6s4y3y2nYCmfDGAtMarWIK4oy2") { (toUser) in
                print(toUser.name)
                sendRequestNotifications(fromUser: fromUser, toUser: toUser, message: "Hello", badge: 1)
            }
        }
        
        
//        let storyboard = UIStoryboard(name: "Channel", bundle: nil)
//        let createChannelVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CREATE_CHANNEL_NAV_CONTROLLER)
//        self.present(createChannelVC, animated: true, completion: nil)
    }
    
    // Switch to settings VC when avatar is tapped
    @objc func avatarButtonDidTapped() {
        self.performSegue(withIdentifier: "settingsVC", sender: nil)
    }

}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pass the channel object to the cell class to display information
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell") as! ChannelTableViewCell
        let channel = self.channelList[indexPath.row]
        cell.delegate = self
        cell.loadData(channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // On selection of row, segue to ChannelDetailVC and send the corresponding channel details over
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChannelTableViewCell {
            let storyboard = UIStoryboard(name: "Channel", bundle: nil)
            let channelDetailVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHANNEL_DETAIL) as! ChannelDetailViewController
            
            // Send the cell details over to channelDetailVC
            channelDetailVC.channelName = cell.channelNameLabel.text
            channelDetailVC.channelId = cell.channel.channelId
            channelDetailVC.channelAvatar = cell.avatar.image
            
            self.navigationController?.pushViewController(channelDetailVC, animated: true)
        }
    }
    
    // Handles swipe action on row - show delete option
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteButton_TouchUpInside(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // When delete is pressed on swipe, show alert popup for final confirmation before deleting
    func deleteButton_TouchUpInside(at indexPath: IndexPath) -> UIContextualAction {
        
        // Show stickersheet with option to cancel or delete
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            let channelName = self.channelList[indexPath.row].channelName
            let alert = UIAlertController(title: "Delete channel", message: "Are you sure you want to delete " + channelName, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                // Delete function
            }))
            
            self.present(alert, animated: true)
        }
        
        action.backgroundColor = BrandColours.PINK
        return action
    }
}

extension ChannelViewController: ChannelProtocol {
    func reloadData() {
        self.tableView.reloadData()
    }
    
    // Switch to stories if applicable, otherwise switch to channel details
    func channelAvatarDidTapped() {
        self.performSegue(withIdentifier: "storiesVC", sender: nil)
    }
}
