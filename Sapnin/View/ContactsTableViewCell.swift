//
//  AddParticipantsTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 27/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var inviteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func inviteButton_TouchUpInside(_ sender: Any) {
        print("pressed")
    }
    

}
