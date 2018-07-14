//
//  AddParticipantsTableViewCell.swift
//  Sapnin
//
//  Created by Alan Lau on 27/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

// Use protocol to pass the action back to tableviewcontroller (CreateChannel2ViewController)
protocol SelectParticipantsTableViewCellDelegate {
    func inviteContact()
}

class SelectParticipantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var inviteButton: UIButton!
    
    var delegate: SelectParticipantsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func inviteButton_TouchUpInside(_ sender: Any) {
        self.delegate?.inviteContact()
    }

}
