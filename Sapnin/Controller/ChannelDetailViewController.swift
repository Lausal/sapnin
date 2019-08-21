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
    var postList = [ChannelPost]()
    var picker = UIImagePickerController()

    var selectedPostId: String!
    
    var sortedUsersFirstLetters: [String] = []
    var sortedUsersPerSections: [[ChannelPost]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        setupPicker()
        setupCollectionView()
        setupNavigationBar()
        observeChannelPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Show tab bar when leaving the page
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // Retrieve the latest channel posts from Firebase
    func observeChannelPosts() {
        Api.ChannelPost.getChannelPosts(channelId: channelId) { (channelPost) in
            
            // Check and make sure channel post object is not already added into the postList (i.e. duplication) by checking if postId already exists in the array
            if !self.postList.contains(where: {$0.postId == channelPost.postId}) {
                
                // If not duplicate, then append to postList array
                self.postList.append(channelPost)
            }
            
            // Sort posts by date
            self.sortPosts()
            
        }
    }
    
    func testSort(onSuccess: @escaping () -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dates = postList.map { dateFormatter.string(from:Date(timeIntervalSince1970: $0.datePosted)) }
        let uniqueDates = Array(Set(dates))
        
        // test
        let dates2 = uniqueDates.compactMap { dateFormatter.date(from: $0) }
        let sortedDates = dates2.sorted { $0 > $1 }
        //print(sortedDates)
        sortedUsersFirstLetters = sortedDates.compactMap { dateFormatter.string(from: $0)}
        //print(sortedUsersFirstLetters)
        
        //sortedUsersFirstLetters = uniqueDates
        //sortedUsersFirstLetters = ["17/08/2019", "14/08/2019", "31/07/2019", "29/07/2019", "26/07/2019", "23/07/2019", "22/07/2019"]
        
        print(sortedUsersFirstLetters.count)
        
        sortedUsersPerSections = sortedUsersFirstLetters.map { date in
            return postList
                .filter { dateFormatter.string(from:Date(timeIntervalSince1970: $0.datePosted)) == date }
                .sorted { $0.datePosted > $1.datePosted }
        }
        
        onSuccess()
        
//        let groupedPosts = Dictionary(grouping: postList) { (element) -> String in
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            let dateUnformat = Date(timeIntervalSince1970: element.datePosted)
//            let date = dateFormatter.string(from: dateUnformat)
//            return date
//
//        }
//
//        let sortedKeys = groupedPosts.keys.sorted()
//        sortedKeys.forEach { (key) in
//            let values = groupedPosts[key]
//
//            chatMessages.append(values ?? [])
//            print(chatMessages[0])
//            //print(values ?? "")
//        }
//        //print(groupedPosts.count)
//        //print(chatMessages.count)
        
        
    }
    
    // Sort posts by date
    func sortPosts() {
        
        postList = postList.sorted(by: {$0.datePosted > $1.datePosted})
        
        testSort {
            //print(self.sortedUsersFirstLetters)
        }
        
        //let firstLetters = userList.map { $0.getFirstLetterOfName }
        //let uniqueFirstLetters = Array(Set(firstLetters))
        //sortedUsersFirstLetters = uniqueFirstLetters.sorted()
        
        
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return 1
        return sortedUsersFirstLetters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.postList.count
        return sortedUsersPerSections[section].count
    }
    
    // Load picture into each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailCollectionViewCell", for: indexPath) as! ChannelDetailCollectionViewCell
        let channelPost = sortedUsersPerSections[indexPath.section][indexPath.row]
        //let channelPost = self.postList[indexPath.item]
        cell.loadData(channelPost)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPostId = sortedUsersPerSections[indexPath.section][indexPath.row].postId
        performSegue(withIdentifier: "imageViewVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set the ImageViewController image variable to selected image on segue
        if segue.identifier == "imageViewVC" {
            let imageVC = segue.destination as! ImageViewController
            imageVC.postList = self.postList
            imageVC.selectedPostId = selectedPostId
            //imageVC.selectedImageNo = selectedImageNo!
        }
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
    
    // Section heading
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChannelDetailSectionHeaderView", for: indexPath) as? ChannelDetailSectionHeaderView {
            
            sectionHeader.dateLabel.text = sortedUsersFirstLetters[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
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
