//
//  ChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 21/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import SDWebImage

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIStackView!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    let userList = ["John, James", "Luke, Alan, Hannah", "Matthew, Rob, Daniel"]
    let timestamp = ["10:14", "20:20", "13:10"]
    var channels = [ChannelModel]()
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds tap gesture to profile
        self.navigationItem.titleView = profileView
        
        setNavigationBarProfileImage()
        loadChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set navigation bar to pink
        self.navigationController?.navigationBar.barTintColor = BrandColours.PINK
        
        // Add gesture recognizer to the navigation bar when the view is about to appear
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileView_TouchUpInside))
        //self.navigationController?.navigationBar.addGestureRecognizer(tapGestureRecognizer)
        self.profileView.addGestureRecognizer(tapGestureRecognizer)
        // This allows controlls in the navigation bar to continue receiving touches
        tapGestureRecognizer.cancelsTouchesInView = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove gesture recognizer from navigation bar when view is about to disappear
        self.navigationController?.navigationBar.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func loadChannels() {
        guard let userId = Api.user.CURRENT_USER?.uid else {return}
        Api.userChannel.observeUserChannel(userId: userId) { (channelId) in
            // After getting all channel ID from UserChannel table, now get all corresponding channel details
            Api.channel.observeChannels(channelId: channelId, onSuccess: { (channel) in
                self.channels.insert(channel, at: 0)
                self.tableView.reloadData()
//                print(channel.users?.count)
//                self.fetchUser(userId: <#T##String#>, onSuccess: {
//                    self.channels.insert(channel, at: 0)
//                    self.tableView.reloadData()
//                })
            })
        }
    }
    
    func fetchUser(userId: String, onSuccess: @escaping () -> Void) {
        Api.user.observeUser(userId: userId) { (user) in
            self.users.insert(user, at: 0)
            onSuccess()
        }
    }
    
    func setNavigationBarProfileImage() {
        Api.user.observeCurrentUser { (user) in
            if let profileUrl = URL(string: user.profileImageUrl!) {
                self.profileImage.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @objc func profileView_TouchUpInside() {
        self.performSegue(withIdentifier: "settingsVC", sender: nil)
    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        // Show camera via transition from left to right
        let cameraStoryBoard : UIStoryboard = UIStoryboard(name: "Camera", bundle:nil)
        let cameraViewController = cameraStoryBoard.instantiateViewController(withIdentifier: "CameraViewController") as UIViewController
        
        let transition = CATransition.init()
        transition.duration = 0
        transition.type = kCATransitionPush //Transition you want like Push, Reveal
        transition.subtype = kCATransitionFromLeft // Direction like Left to Right, Right to Left
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(cameraViewController, animated: false, completion: nil)
    }

}

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4Participants") as! ChannelTableViewCell
        let channel = channels[indexPath.row]
        
        cell.channelNameLabel.text = channel.channelName
        
        // REPLACE WITH REAL DATA
        cell.userListLabel.text = "NEEDS DATA"
        cell.timestampLabel.text = "10:10"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        //self.performSegue(withIdentifier: "PhotoVC", sender: nil)
        self.performSegue(withIdentifier: "ChannelDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let more = moreButton_TouchUpInside(at: indexPath)
        let delete = deleteButton_TouchUpInside(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, more])
    }
    
    func moreButton_TouchUpInside(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "More") { (action, view, completion) in
            // Function here
            completion(true)
        }
        action.backgroundColor = ColourPalette.LIGHT_GREY
        return action
    }
    
    // When delete is pressed, show alert popup for final confirmation before deleting
    func deleteButton_TouchUpInside(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            guard let channelName = self.channels[indexPath.row].channelName else { return }
            let alert = UIAlertController(title: "Delete channel", message: "Are you sure you want to delete " + channelName, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                guard let channelId = self.channels[indexPath.row].channelId else { return }
                Api.channel.deleteChannel(channelId: channelId, onSuccess: {
                    self.channels.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true) // This collapses the slide out menu
                })
            }))
            
            self.present(alert, animated: true)
        }
        
        action.backgroundColor = ColourPalette.PINK
        return action
    }
}
