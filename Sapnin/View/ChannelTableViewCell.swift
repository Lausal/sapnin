//
//  ChannelTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCellStyle()
    }
    
    func setupCellStyle() {
        
        // Style avatar
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true
        
    }

}
