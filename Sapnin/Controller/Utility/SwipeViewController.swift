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
        
        let CameraViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! UIViewController
        self.addChildViewController(CameraViewController)
        self.scrollView.addSubview(CameraViewController.view)
        CameraViewController.didMove(toParentViewController: self)
        CameraViewController.view.bounds = scrollView.bounds
        
        let channelStoryboard = UIStoryboard(name: "Channel", bundle: nil)
        let ChannelViewController = channelStoryboard.instantiateViewController(withIdentifier: "NavChannelViewController") as! UIViewController
        self.addChildViewController(ChannelViewController)
        self.scrollView.addSubview(ChannelViewController.view)
        ChannelViewController.didMove(toParentViewController: self)
        ChannelViewController.view.bounds = scrollView.bounds
        
        var ChannelViewControllerFrame: CGRect = ChannelViewController.view.frame
        ChannelViewControllerFrame.origin.x = self.view.frame.width
        ChannelViewController.view.frame = ChannelViewControllerFrame
        
        self.scrollView.contentSize = CGSize(width: (self.view.frame.width) * 2, height: self.view.frame.size.height)
        //self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }


}
