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
protocol ChannelProtocol {
    func reloadData()
    func channelAvatarDidTapped(channelId:String)
}

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderContainer: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var newStoryDot: UIView!
    
    var channelStories = [ChannelPost]()
    var controller: ChannelViewController!
    var channel: Channel!
    var delegate: ChannelProtocol!
    
    // Observe functionality will continue to sink data even if we leave the view, so we need a handler to remove the observe when leaving view to reduce constant memory sync
    var channelChangedAvatarHandle: DatabaseHandle!
    var channelChangedMessageHandle: DatabaseHandle!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style avatar
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true
        
        // Style pink dot
        newStoryDot.layer.cornerRadius = 6
        newStoryDot.layer.borderColor = UIColor.white.cgColor
        newStoryDot.layer.borderWidth = 1
        
        // Add tap gesture to channel avatar
        let tap = UITapGestureRecognizer(target: self, action: #selector(channelAvatarDidTapped))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tap)
    }
    
    // On tap of channel avatar, call the channelAvatarDidTapped method which either switches to the stories, or channel details page.
    @objc func channelAvatarDidTapped() {
        if channelStories.count == 0{
            return
        }
        self.delegate.channelAvatarDidTapped(channelId: channel.channelId)
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
        
        let dForm               = DateFormatter.init()
        dForm.dateFormat        = "yyyy-MM-dd"
        self.dateLabel.text     = ""
        
        let postDate = Date(timeIntervalSince1970: channel.lastMessageDate)
        borderContainer.drawBorder(withNumberOfDots: 0)
        
        Api.ChannelPost.getAllStoriesForChannel(channelId: channel.channelId) { (channelPosts) in
            if channelPosts != nil{
                self.channelStories = channelPosts!
                self.borderContainer.drawBorder(withNumberOfDots: self.channelStories.count)
        
                if self.channelStories.count > 0{
                    dForm.dateFormat = "HH:mm"
                    self.dateLabel.text = dForm.string(from: postDate)
                }else{
                    dForm.dateFormat = "EEE"
                    self.dateLabel.text = dForm.string(from: postDate)
                }
            }else{
                dForm.dateFormat = "EEE"
                self.dateLabel.text = dForm.string(from: postDate)
            }
        }
        
        
        if let users = channel.users{
            if users.count == 0{
                messageLabel.text = "me"
                return
            }
            
            var usernames = ""
            for i in 0...users.count-1{
                let user = users[i]
                
                for key in user.keys{
                    if let k = user[key] as? [String:Any]{
                        if "\(k["name"]!)" == UserDefaults.standard.value(forKey: USER_NAME) as? String{
                            usernames.append("me, ")
                        }else{
                            usernames.append("\(k["name"]!)".components(separatedBy: " ").first!+", ")
                        }
                    }else{
                        if "\(user[key]!)" == UserDefaults.standard.value(forKey: USER_NAME) as? String{
                            usernames.append("me, ")
                        }else{
                            usernames.append("\(user[key]!)".components(separatedBy: " ").first!+", ")
                        }
                    }
                }
            }

            messageLabel.text = String(usernames.dropLast(2))
            
        }else{
            messageLabel.text = "me"
        }
        
        
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
