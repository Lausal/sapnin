//
//  ImageCollectionViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 27/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var channelPost: ChannelPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    // Load the data into the cell
//    func loadData(passedImage: UIImage) {
//        self.image.image = passedImage
//    }
    
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
