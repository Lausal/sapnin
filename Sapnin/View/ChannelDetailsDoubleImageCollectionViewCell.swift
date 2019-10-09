//
//  ChannelDetailsDoubleImageCollectionViewCell.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 12/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ChannelDetailsDoubleImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func loadData(_ channelPost: [ChannelPost]) {
        
        // Set image of cell
        firstPhoto.loadImage(channelPost[0].imageUrl)
        secondPhoto.loadImage(channelPost[1].imageUrl)
        
        categoryLabel.text = channelPost[0].category
        
        firstPhoto.layer.cornerRadius   = 5
        secondPhoto.layer.cornerRadius  = 5
        
    }
    
}
