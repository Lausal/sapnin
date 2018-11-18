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
    
    var channelId: String = ""
    var channelName: String = ""
    
    let imageArray = [UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham")]
    let dateArray = ["Today", "Yesterday", "Monday", "Sunday"]
    
    let leftAndRightPadding: CGFloat = 60.0 // 3 x 20px white gaps per row
    let numberOfItemsPerRow: CGFloat = 2.0
    let labelSizeAndTopPadding: CGFloat = 44.0 // 6px top spacing + 18px label height + 2px top spacing + 18px label height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = channelName
        // Set navigation bar to white and status bar to black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default
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
        cell.photo.image = imageArray[indexPath.item]
        cell.dateLabel.text = dateArray[indexPath.row]
        return cell
    }
}

extension ChannelDetailViewController: UICollectionViewDelegateFlowLayout {
    
    // Size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - leftAndRightPadding) / numberOfItemsPerRow
        return CGSize(width: width, height: width + labelSizeAndTopPadding)
    }
    
    // Space between each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//extension UINavigationController {
//    open override var childViewControllerForStatusBarStyle: UIViewController? {
//        return topViewController
//    }
//}

