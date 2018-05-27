//
//  LeaderboardViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 19/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var goldProfileImage: UIImageView!
    @IBOutlet weak var silverProfileImage: UIImageView!
    @IBOutlet weak var bronzeProfileImage: UIImageView!
    @IBOutlet weak var fourthProfileImage: UIImageView!
    
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var silverLabel: UILabel!
    @IBOutlet weak var bronzeLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    override func viewDidLoad() {
        setScores()
        super.viewDidLoad()
    }
    
    func setScores() {
        goldLabel.text = "🥇 5"
        silverLabel.text = "🥈 10"
        bronzeLabel.text = "🥉 3"
        fourthLabel.text = "💩 1"
    }

}
