//
//  ChannelDetailSingleImageCollectionViewCell.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 12/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ChannelDetailSingleImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func loadData(_ channelPost: [ChannelPost]) {
        firstPhoto.loadImage(channelPost[0].imageUrl)
        categoryLabel.text = channelPost[0].category
        firstPhoto.layer.cornerRadius   = 5
    }
}
