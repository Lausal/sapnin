//
//  AddParticipantsTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 27/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class CreateChannelStep1TableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var radioButton: UIImageView!
    @IBOutlet weak var inviteButton: UIButton!
    
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Style avatar
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true
        
        inviteButton.layer.cornerRadius = 5
    }

    // Load the user data into the cell
    func loadData(_ user: User) {
        self.user = user
        
        nameLabel.text = user.name
        
        // Set avatar image if user has one, otherwise use a default image
        if user.profilePictureUrl != nil {
            avatar.loadImage(user.profilePictureUrl)
        } else {
            avatar.image = UIImage(named: "no_profile_icon")
        }
    }
    
}
