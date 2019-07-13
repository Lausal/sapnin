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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTestData()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // DELETE THIS - WE NEED TO GRAB THE LIST OF USERS
    func addTestData() {
        
    }
    
    // Tableview styling
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Pass the user object to the cell class to display the information
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChannelStep1TableViewCell") as! CreateChannelStep1TableViewCell
//        let channel = self.channelList[indexPath.row]
//        cell.delegate = self
//        cell.loadData(channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
}
