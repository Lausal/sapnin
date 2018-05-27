//
//  ChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 21/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let channelName = ["Golf Gang", "Sporty People", "Crackheads"]
    let userList = ["John, James", "Luke, Alan, Hannah", "Matthew, Rob, Daniel"]
    let timestamp = ["10:14", "20:20", "13:10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
