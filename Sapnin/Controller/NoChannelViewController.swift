//
//  NoChannelViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 21/04/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class NoChannelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createChannelButton_TouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "createChannel1VC", sender: nil)
    }
}
