//
//  SwipeViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 15/07/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //guard let tableViewRef = ChannelViewController().tableView else {return}
        //scrollView.touchesShouldCancel(in: tableViewRef)
        
        // Reference view controllers that will go into the scrollview
        let cameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! UIViewController
        
        let channelStoryboard = UIStoryboard(name: "Channel", bundle: nil)
        let channelViewController = channelStoryboard.instantiateViewController(withIdentifier: "NavChannelViewController") as! UIViewController
        
        // Now add to the view controller and scrollview, 1st one added will be displayed first
        self.addChildViewController(cameraViewController)
        self.scrollView.addSubview(cameraViewController.view)
        cameraViewController.didMove(toParentViewController: self)
        
        self.addChildViewController(channelViewController)
        self.scrollView.addSubview(channelViewController.view)
        channelViewController.didMove(toParentViewController: self)
        
        // Set frame of view, x origin is off the screen to the right
        var channelViewControllerFrame: CGRect = channelViewController.view.frame
        channelViewControllerFrame.origin.x = self.view.frame.width
        channelViewController.view.frame = channelViewControllerFrame
        
        self.scrollView.contentSize = CGSize(width: (self.view.frame.width) * 2, height: self.view.frame.size.height)
    }
    
}
