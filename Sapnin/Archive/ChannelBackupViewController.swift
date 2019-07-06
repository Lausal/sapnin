////
////  ChannelViewController.swift
////  Sapnin
////
////  Created by Alan Lau on 21/05/2018.
////  Copyright © 2018 lau. All rights reserved.
////
//
//import UIKit
//import FirebaseAuth
//import FirebaseMessaging
//
//class ChannelTableViewController: UITableViewController {
//    
//    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
//    
//    // This is for the search bar, specifying nil means the search results will appear on the same/current page
//    //var searchController: UISearchController = UISearchController(searchResultsController: nil)
//    
//    var tapGestureRecognizer: UITapGestureRecognizer!
//    
//    var selectedChannelId: String = ""
//    var selectedChannelName: String = ""
//    
//    let userList = ["John, James", "Luke, Alan, Hannah", "Matthew, Rob, Daniel"]
//    let timestamp = ["10:14", "20:20", "13:10"]
//    var channels = [ChannelModel]()
//    var users = [UserModel]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupNavigationBar()
//        //setupSearchBarController()
//        
//        //loadChannels()
//    }
//    
//    //    // Function to make search bar appear and its settings
//    //    func setupSearchBarController() {
//    //        //searchController.dimsBackgroundDuringPresentation = true
//    //        searchController.searchBar.placeholder = "Search"
//    //        searchController.searchBar.barTintColor = UIColor.white
//    //        //searchController.obscuresBackgroundDuringPresentation = false
//    //        //definesPresentationContext = true
//    //        navigationItem.hidesSearchBarWhenScrolling = false
//    //        navigationItem.searchController = searchController
//    //    }
//    
//    func loadChannels() {
//        guard let userId = Api.User.CURRENT_USER?.uid else {return}
//        Api.userChannel.observeUserChannel(userId: userId) { (channelId) in
//            // After getting all channel ID from UserChannel table, now get all corresponding channel details
//            Api.Channel.observeChannels(channelId: channelId, onSuccess: { (channel) in
//                self.channels.insert(channel, at: 0)
//                self.tableView.reloadData()
//                //                print(channel.users?.count)
//                //                self.fetchUser(userId: <#T##String#>, onSuccess: {
//                //                    self.channels.insert(channel, at: 0)
//                //                    self.tableView.reloadData()
//                //                })
//            })
//        }
//    }
//    
//    func fetchUser(userId: String, onSuccess: @escaping () -> Void) {
//        Api.User.observeUser(userId: userId) { (user) in
//            self.users.insert(user, at: 0)
//            onSuccess()
//        }
//    }
//    
//    func setupNavigationBar() {
//        navigationItem.title = "Channels"
//        
//        // Set large navigation bar style
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        // Set title colour to pink
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: BrandColours.PINK]
//        
//        // Add new group button to top right of header
//        let newGroupButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newGroupButtonDidTapped))
//        self.navigationItem.rightBarButtonItem = newGroupButton
//        
//        // Style and create container to hold avatar on header
//        let avatarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
//        avatarImageView.contentMode = .scaleAspectFill
//        avatarImageView.layer.cornerRadius = 16
//        avatarImageView.clipsToBounds = true
//        avatarImageView.isUserInteractionEnabled = true
//        avatarContainerView.addSubview(avatarImageView)
//        
//        // Add tap gesture to avatar image
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarButtonDidTapped))
//        avatarImageView.addGestureRecognizer(tapGesture)
//        
//        // Add avatar button/image to left bar button on header
//        let avatarButton = UIBarButtonItem(customView: avatarContainerView)
//        self.navigationItem.leftBarButtonItem = avatarButton
//        
//        // Load avatar image
//        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
//            avatarImageView.loadImage(photoUrl.absoluteString)
//        }
//    }
//    
//    // Switch to CreateGroupVC when new group button is tapped
//    @objc func newGroupButtonDidTapped() {
//        //        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
//        //        let radarVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_RADAR) as! RadarViewController
//        //        self.navigationController?.pushViewController(radarVC, animated: true)
//    }
//    
//    // Switch to settings VC when avatar is tapped
//    @objc func avatarButtonDidTapped() {
//        self.performSegue(withIdentifier: "settingsVC", sender: nil)
//    }
//    
//    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
//        // Show camera via transition from left to right
//        let cameraStoryBoard : UIStoryboard = UIStoryboard(name: "Camera", bundle:nil)
//        let cameraViewController = cameraStoryBoard.instantiateViewController(withIdentifier: "CameraViewController") as UIViewController
//        
//        let transition = CATransition.init()
//        transition.duration = 0
//        transition.type = kCATransitionPush //Transition you want like Push, Reveal
//        transition.subtype = kCATransitionFromLeft // Direction like Left to Right, Right to Left
//        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(cameraViewController, animated: false, completion: nil)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ChannelDetailVC") {
//            let viewController = segue.destination as! ChannelDetailViewController
//            viewController.channelId = self.selectedChannelId
//            viewController.channelName = self.selectedChannelName
//        }
//    }
//    
//}
//
////extension ChannelTableViewController: UITableViewDelegate, UITableViewDataSource {
////
////    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 80
////    }
////
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 80
////    }
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return channels.count
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4Participants") as! ChannelTableViewCell
////        let channel = channels[indexPath.row]
////
////        cell.channelNameLabel.text = channel.channelName
////
////        // REPLACE WITH REAL DATA
////        cell.userListLabel.text = "NEEDS DATA"
////        cell.timestampLabel.text = "10:10"
////
////        return cell
////    }
////
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        self.selectedChannelId = self.channels[indexPath.row].channelId!
////        self.selectedChannelName = self.channels[indexPath.row].channelName!
////
////        self.performSegue(withIdentifier: "ChannelDetailVC", sender: nil)
////    }
////
////    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
////        let more = moreButton_TouchUpInside(at: indexPath)
////        let delete = deleteButton_TouchUpInside(at: indexPath)
////        return UISwipeActionsConfiguration(actions: [delete, more])
////    }
////
////    func moreButton_TouchUpInside(at indexPath: IndexPath) -> UIContextualAction {
////        let action = UIContextualAction(style: .normal, title: "More") { (action, view, completion) in
////            // Function here
////            completion(true)
////        }
////        action.backgroundColor = ColourPalette.LIGHT_GREY
////        return action
////    }
////
////    // When delete is pressed, show alert popup for final confirmation before deleting
////    func deleteButton_TouchUpInside(at indexPath: IndexPath) -> UIContextualAction {
////        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
////            guard let channelName = self.channels[indexPath.row].channelName else { return }
////            let alert = UIAlertController(title: "Delete channel", message: "Are you sure you want to delete " + channelName, preferredStyle: .alert)
////
////            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
////
////            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
////                guard let channelId = self.channels[indexPath.row].channelId else { return }
////                Api.Channel.deleteChannel(channelId: channelId, onSuccess: {
////                    self.channels.remove(at: indexPath.row)
////                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
////                    completion(true) // This collapses the slide out menu
////                })
////            }))
////
////            self.present(alert, animated: true)
////        }
////
////        action.backgroundColor = ColourPalette.PINK
////        return action
////    }
////}
