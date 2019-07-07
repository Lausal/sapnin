//
//  ChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 21/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging

class ChannelTableViewController: UITableViewController {
    
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    // This is for the search bar, specifying nil means the search results will appear on the same/current page
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBarController()
    }
    
    // Function to make search bar appear and its settings
    func setupSearchBarController() {
        //searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = UIColor.white
        //searchController.obscuresBackgroundDuringPresentation = false
        //definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Channels"
        
        // Set large navigation bar style
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set title colour to pink
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: BrandColours.PINK]
        
        // Add new group button to top right of header
        let newGroupButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newGroupButtonDidTapped))
        self.navigationItem.rightBarButtonItem = newGroupButton
        
        // Style and create container to hold avatar on header
        let avatarContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarContainerView.addSubview(avatarImageView)
        
        // Add tap gesture to avatar image
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarButtonDidTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        // Add avatar button/image to left bar button on header
        let avatarButton = UIBarButtonItem(customView: avatarContainerView)
        self.navigationItem.leftBarButtonItem = avatarButton
        
        // Load avatar image
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
    }
    
    // Switch to CreateGroupVC when new group button is tapped
    @objc func newGroupButtonDidTapped() {
        let storyboard = UIStoryboard(name: "Channel", bundle: nil)
        let createChannelVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CREATE_CHANNEL_NAV_CONTROLLER)
        self.present(createChannelVC, animated: true, completion: nil)
    }
    
    // Switch to settings VC when avatar is tapped
    @objc func avatarButtonDidTapped() {
        self.performSegue(withIdentifier: "settingsVC", sender: nil)
    }

}
