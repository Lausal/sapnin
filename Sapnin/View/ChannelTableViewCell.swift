//
//  ChannelTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 07/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit
import Firebase

// Protocols allow us to call functions in another VC
protocol UpdateTableProtocol {
    func reloadData()
}

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var channel: Channel!
    var delegate: UpdateTableProtocol!
    
    // Observe functionality will continue to sink data even if we leave the view, so we need a handler to remove the observe when leaving view to reduce constant memory sync
    var channelChangedAvatarHandle: DatabaseHandle!
    var channelChangedMessageHandle: DatabaseHandle!
    
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
        
        // Configure timestamp based on timelapse between creation date and current date
        let date = Date(timeIntervalSince1970: channel.dateCreated)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString
        
        messageLabel.text = "Luke posted a photo"
        
        /*** Observe channel avatar for changes, so we can automatically update the avatar. ***/
        
        let refChannel = Ref().databaseSpecificChannelRef(channelId: channel.channelId)
        if channelChangedAvatarHandle != nil {
            refChannel.removeObserver(withHandle: channelChangedAvatarHandle)
        }
        
        channelChangedAvatarHandle = refChannel.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String{
                self.channel.updateData(key: snapshot.key, value: snap)
                self.delegate.reloadData()
            }
        })
    }
    
    // Called everytime cell is reused (I.e. new row created on tableview) to help clean up and ease the process
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let refChannel = Ref().databaseSpecificChannelRef(channelId: channel.channelId)
        if channelChangedAvatarHandle != nil {
            refChannel.removeObserver(withHandle: channelChangedAvatarHandle)
        }
    }

}
