//
//  ChannelDetailViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 19/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationStyle()
    }
    
    func setupNavigationStyle() {
        self.title = "Channel Name"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
