//
//  SelectChannelTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 15/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class SelectChannelTableViewCell: UITableViewCell {
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var channelNameLabel: UILabel!
    @IBOutlet var radioButton: UIImageView!
    
    var channel: Channel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style avatar
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true
    }
    
    // Load the channel data into the cell
    func loadData(_ channel: Channel) {
        
        self.channel = channel
        
        // Set avatar image if channel has one, otherwise use a default image
        if channel.channelAvatarUrl != nil {
            avatar.loadImage(channel.channelAvatarUrl)
        } else {
            avatar.image = UIImage(named: "no_profile_icon")
        }
        
        self.channelNameLabel.text = channel.channelName
        
    }

}
