//
//  ChannelDetailViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 19/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit

class ChannelDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var channelAvatarImage: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    
    var channelId: String!
    var channelName: String!
    var channelAvatar: UIImage!
    
    let imageArray = [UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham"),UIImage(named: "david beckham")]
    
    var picker = UIImagePickerController()
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicker()
        setupCollectionView()
        setupNavigationBar()
    }
    
    // Set up photo picker
    func setupPicker() {
        picker.delegate = self
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        
        // Setting channel title
        channelTitleLabel.text = channelName
        
        // Setting channel avatar image and style
        channelAvatarImage.layer.cornerRadius = 16
        channelAvatarImage.clipsToBounds = true
        channelAvatarImage.image = channelAvatar
        
        // Set small navigation bar style
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Add photo button to top right of header
        let photoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(photoButtonDidTapped))
        self.navigationItem.rightBarButtonItem = photoButton
        
    }
    
    // On tap of photo button - open up stickersheet to add photo or use camera
    @objc func photoButtonDidTapped() {
        let actionSheet = UIAlertController()
        
        // Show camera option
        let camera = UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default) { (_) in
            // This checks if camera is available on phone
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        
        // Show photo library option
        let photoLibrary = UIAlertAction(title: "Choose a photo", style: UIAlertAction.Style.default) { (_) in
            // This checks if photo library is available on phone
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            } else {
                print("Unavailable")
            }
        }
        
        // Show cancel option
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        // Add options to actionsheet
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        // Show picker
        present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ChannelDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    // Load picture into each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailCollectionViewCell", for: indexPath) as! ChannelDetailCollectionViewCell
        cell.photo.image = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // Specify width and height of each grid/cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Make each cell 1/4 of the screen size so we fit 4 per row (We - 1.5 because we want to make the space between each cell 0.5, of which therefore means a 1.5 as there're 3 gaps.)
        return CGSize(width: view.frame.size.width/4 - 1.5, height: view.frame.size.width/4 - 1.5)
    }
    
    // Specify space between each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    // Specify space between each cell on the same row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// Handle image and camera picker
extension ChannelDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Handles when user finishes picking or taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Extract image from selection/camera. The photo is extracted from 'info' dictionary response once user takes a picture or selects a picture from photo library
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage? {
            
            // Pass & set the previewVC image variable to the selected image
            let storyboard = UIStoryboard(name: "Channel", bundle: nil)
            let previewVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_PREVIEW) as! PreviewViewController
            previewVC.selectedImage = image!
            previewVC.channelId = channelId
            
            // Get the top hierarchy VC and show the previewVC on top of it as a modal
            DispatchQueue.main.async {
                Utility().getTopMostViewController()?.present(previewVC, animated: true, completion: nil)
            }
            
        }
        
    }
    
}
