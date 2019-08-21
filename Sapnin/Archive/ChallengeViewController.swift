//
//  ChallengeViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 13/05/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let iconName = ["copy_icon.png", "dance_icon.png", "sing_icon.png", "drink_icon.png", "sketch_icon.png", "act_icon.png"]
    let challengeTitle = ["Copy this", "Do this dance", "Sing", "Drink up", "Draw this", "Do this act"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButton_TouchUpInside(_ sender: Any) {
        // Set challengeSelected variable from CameraViewController class to selected value
        if let cameraViewController = presentingViewController as? CameraViewController {
            cameraViewController.challengeDidChange = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}

extension ChallengeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChallengeTableViewCell
        cell.icon.image = UIImage(named: iconName[indexPath.row])
        cell.title.text = challengeTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set challengeSelected variable from CameraViewController class to selected value
        if let cameraViewController = presentingViewController as? CameraViewController {
            cameraViewController.challengeSelected = challengeTitle[indexPath.row]
            cameraViewController.challengeDidChange = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
