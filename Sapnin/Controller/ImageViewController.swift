//
//  ImageViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 26/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Holds the list of post objects
    var postList = [ChannelPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
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
