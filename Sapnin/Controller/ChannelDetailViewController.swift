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
    
    let imageArray = [UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham")]
    let dateArray = ["Today", "Yesterday", "Monday", "Sunday"]
    
    let leftAndRightPadding: CGFloat = 60.0 // 3 x 20px white gaps per row
    let numberOfItemsPerRow: CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationStyle()
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (collectionView.frame.size.width - leftAndRightPadding) / numberOfItemsPerRow, height: (collectionView.frame.size.width - leftAndRightPadding) / numberOfItemsPerRow)
        
        //var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20) // Margin in each cell
        //layout.minimumInteritemSpacing = 10 // Space between each cell
        //layout.itemSize = CGSize(width: 100, height: 100)
        //layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 40)/2, height: (self.collectionView.frame.size.height)/3) // Divide by 3 because we want 3 cells in each screen
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        self.setupGridView()
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
    
    func setupNavigationStyle() {
        self.title = "Channel Name"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let backButton = UIBarButtonItem()
        backButton.title = "" //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
//    func setupGridView() {
//        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
//        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
//    }
    
}

extension ChannelDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChannelDetailCollectionViewCell
        cell.photo.image = imageArray[indexPath.item]
        //cell.dateLabel.text = dateArray[indexPath.row]
        return cell
    }
}

//extension ChannelDetailViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = self.calculateWidth()
//        return CGSize(width: width, height: width)
//    }
//
//    func calculateWidth() -> CGFloat {
//        let estimatedWidth = CGFloat(estimateWidth)
//        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
//        let margin = CGFloat(cellMarginSize * 2)
//        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
//        return width
//    }
//}

