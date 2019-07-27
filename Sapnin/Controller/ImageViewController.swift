//
//  ImageViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 26/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImageView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupScrollView()
        
        // Set zoom scale of the image
        setZoomScale(for: scrollView.bounds.size)
        
        // After setting zoom scale, we make the image load with the minimum zoom scale by default
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        // Center the image on load
        recenterImage()
        
    }
    
    func setupView() {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show tab bar when view exits
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // Set up the scrollview and add it to the view
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .white
        
        // Scrollview interaction area will only apply to the image
        scrollView.contentSize = image.bounds.size
        
        scrollView.delegate = self
        scrollView.addSubview(image)
        
        view.addSubview(scrollView)
    }
    
    // Set image/scrollview zoom level
    func setZoomScale(for scrollViewSize: CGSize) {
        
        // Get image size and calculate scale (Aspect ratio)
        let imageSize = image.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minimumScale = min(widthScale, heightScale)
        
        // Set minimum zoom scale to fit the image on screen
        scrollView.minimumZoomScale = minimumScale
        
        // Set zoom level up to 3x default size
        scrollView.maximumZoomScale = 3.0
    }
    
    // Recenters the image - called on zoom to make sure the image is always center aligned
    func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = image.frame.size
        
        // Get the horizontal unused space
        let horiztonalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2.0 : 0
        
        // Get the vertical unused space (I.e. the black bits top and bottom when you view on photos)
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2.0 : 0
        
        // If navigation bar is shown, then we still want to give it some extra space top between nav bar and image
        let extraSpace: CGFloat
        if navigationController != nil {
            extraSpace = navigationController!.navigationBar.bounds.size.height
        } else {
            extraSpace = 0
        }
        
        // Now center the image/scrollview using calculations above
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace - extraSpace, left: horiztonalSpace, bottom: verticalSpace, right: horiztonalSpace)
    }
    
}

extension ImageViewController: UIScrollViewDelegate {
    
    // Tells the delegate which view that requires zoom in and zoom out - in our case it's the imageView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    // When zooming on image, we call recenter function so that the image is always centered on zoom (Like photos)
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }
    
}
