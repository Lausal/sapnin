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
    
    let channelName = ["Golf Gang", "Sporty People", "Crackheads"]
    let userList = ["John, James", "Luke, Alan, Hannah", "Matthew, Rob, Daniel"]
    let timestamp = ["10:14", "20:20", "13:10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds tap gesture
        self.navigationItem.titleView = profileView
        
        setNavigationBarProfileImage()
        
        let userId = Api.user.CURRENT_USER?.uid
        Api.userChannel.observeUserChannel(userId: userId!) { (channelId) in
            print(channelId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        self.performSegue(withIdentifier: "cameraVC", sender: nil)
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
        return channelName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4Participants") as! ChannelTableViewCell
        cell.channelNameLabel.text = channelName[indexPath.row]
        cell.userListLabel.text = userList[indexPath.row]
        cell.timestampLabel.text = timestamp[indexPath.row]
        return cell
    }
}
