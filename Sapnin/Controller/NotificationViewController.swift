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
        
        // Add broadcast button to top right of header
        let broadcastButton = UIBarButtonItem(image: UIImage(named: "broadcast_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(broadcastButtonDidTapped))
        self.navigationItem.rightBarButtonItem = broadcastButton
    }
    
    // Show broadcast page
    @objc func broadcastButtonDidTapped() {
        let storyboard = UIStoryboard(name: "Channel", bundle: nil)
        let broadcastVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_BROADCAST_NAV_CONTROLLER)
        self.present(broadcastVC, animated: true, completion: nil)
    }

}
