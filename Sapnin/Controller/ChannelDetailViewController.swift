//
//  ChannelDetailViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 19/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [UIImage(named: "selfie_image1"),UIImage(named: "selfie_image2"),UIImage(named: "selfie_image3"),UIImage(named: "selfie_image4")]
    
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

extension ChannelDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChannelDetailCollectionViewCell
        cell.photo.image = imageArray[indexPath.row]
        return cell
    }
}
