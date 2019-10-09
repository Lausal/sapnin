//
//  ChannelDetailsQuadImageCollectionViewCell.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 12/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ChannelDetailsQuadImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var thirdPhoto: UIImageView!
    @IBOutlet weak var fourthPhoto: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func loadData(_ channelPost: [ChannelPost]) {
        
        firstPhoto.loadImage(channelPost[0].imageUrl)
        secondPhoto.loadImage(channelPost[1].imageUrl)
        thirdPhoto.loadImage(channelPost[2].imageUrl)
        fourthPhoto.loadImage(channelPost[3].imageUrl)
        categoryLabel.text = channelPost[0].category
        firstPhoto.layer.cornerRadius   = 5
        secondPhoto.layer.cornerRadius  = 5
        thirdPhoto.layer.cornerRadius   = 5
        fourthPhoto.layer.cornerRadius  = 5
        
    }
    
}
