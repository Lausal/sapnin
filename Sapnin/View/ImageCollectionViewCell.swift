//
//  ImageCollectionViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 27/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    
    var channelPost: ChannelPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        
        // Set zoom level
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
    // Load the data into the cell
    func loadData(_ channelPost: ChannelPost) {
        self.channelPost = channelPost
        
        // Set image of cell
        if channelPost.imageUrl != nil {
            image.loadImage(channelPost.imageUrl)
        } else {
            return
        }
    }
    
}

extension ImageCollectionViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
}
