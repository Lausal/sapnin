//
//  BroadcastViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class BroadcastViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let emojiList = ["📺", "🍔", "⚽️", "💼", "🏋️‍♂️", "🎮", "🍺", "😩"]
    let activityList = ["Watching TV", "Eating", "Playing sports", "At work", "Pumping iron", "Gaming", "Out drinking", "Bored"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }

    // Tableview styling
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorStyle = .none
        tableView.allowsSelection = true
        
        // Add footer to bottom to cover up additional line seperators
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar() {
        title = "Broadcast"
        
        // Add cancel button to top left of header
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButtonDidTapped))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // Revert back to notifications VC when cancel is tapped
    @objc func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension BroadcastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Show the emoji label and activity label in each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BroadcastTableViewCell") as! BroadcastTableViewCell
        cell.emojiLabel.text = emojiList[indexPath.row]
        cell.activityLabel.text = activityList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // On selection of row, segue to SelectChannelVC and send the corresponding selected activity over
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BroadcastTableViewCell {
            let storyboard = UIStoryboard(name: "Channel", bundle: nil)
            let selectChannelVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_SELECT_CHANNEL) as! SelectChannelViewController
            
            // Send the cell activity and emoji labels to SelectChannelVC
            selectChannelVC.activity = cell.activityLabel.text
            selectChannelVC.emoji = cell.emojiLabel.text
            
            self.navigationController?.pushViewController(selectChannelVC, animated: true)
        }
    }
}
