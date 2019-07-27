//
//  ChannelDetailCollectionViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 21/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    var channelPost: ChannelPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Load the data into the cell
    func loadData(_ channelPost: ChannelPost) {
        self.channelPost = channelPost
        
        // Set image of cell
        if channelPost.imageUrl != nil {
            print("running")
            photo.loadImage(channelPost.imageUrl)
        } else {
            return
        }
    }

}
