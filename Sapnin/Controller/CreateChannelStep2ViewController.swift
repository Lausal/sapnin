//
//  CreateChannelStep2ViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class CreateChannelStep2ViewController: UIViewController {
    
    var channelName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Add friends"
        
        // Add create button to top right of header
        let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.createButtonDidTapped))
        self.navigationItem.rightBarButtonItem = createButton
    }
    
    @objc func createButtonDidTapped() {
        Api.Channel.createChannel(channelName: channelName!) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
