//
//  NotificationViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Notifications"
        
        // Set large navigation bar style
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set title colour to pink
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: BrandColours.PINK]
    }

}
