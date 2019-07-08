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
        self.channelNameLabel.text = channel.channelName
        
        // Configure timestamp based on timelapse between creation date and current date
        let date = Date(timeIntervalSince1970: channel.dateCreated)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString
        
        messageLabel.text = "Luke posted a photo"
    }

}
