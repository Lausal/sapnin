//
//  ImageViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 26/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    // Holds the list of post objects
    var postList = [ChannelPost]()
    var selectedImageNo = IndexPath()
    var selectedPostId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        scrollToImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Show tab bar when leaving the page
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // Scroll to the selected image from the channel details page - This is called after view has laid everything out using view.layoutIfNeeded()
    func scrollToImage() {
        
        view.layoutIfNeeded()
        
        // Get the index of the selected post by finding the array index of matching ID
        let index = postList.index(where: { $0.postId == selectedPostId })
        
        // Scroll to the selected image
        collectionView.scrollToItem(at: IndexPath(item: index!, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    // Set up the collectionview styling and interaction
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set horizontal scroll
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // Enable paging
        collectionView.isPagingEnabled = true
        
        // Hide pagination indicator
        collectionView.showsHorizontalScrollIndicator = false
        
        // Set background colour
        collectionView.backgroundColor = UIColor.black
        
        // Make collectionview full width to include the safe areas
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        
    }

}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    // Load picture into each cell by passing each post object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let channelPost = self.postList[indexPath.item]
        cell.loadData(channelPost)
        return cell
    }
    
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
    
    // Set the collectionView as full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    // Set collectionview insets as 0 so it takes up full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Set collectionView as no line between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Set collectionView as no line between columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
