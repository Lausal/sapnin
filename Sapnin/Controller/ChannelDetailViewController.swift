//
//  ChannelDetailViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 19/06/2018.
//  Copyright © 2018 lau. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
//import SwiftTransition


class ChannelDetailViewController: UIViewController {

    enum ViewType: Int {
        case all = 1
        case category = 2
    }
    
    @IBOutlet weak var storyViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var channelAvatarImage: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var noCategoryView: UIView!
    @IBOutlet weak var noPostLabel: UILabel!
    
    var channelId: String!
    var channelName: String!
    var channelAvatar: UIImage!
    var userIDList = [[String:Any]]()
    var postList = [ChannelPost]()
    var storiesList = [ChannelPost]()
    var categorisedPostList = [[ChannelPost]]()
    var picker = UIImagePickerController()

    var lastContentOffset: CGFloat = 0
    var viewType : ViewType!
    var selectedPostId: String!
    var sortedUsersFirstLetters: [String] = []
    var sortedUsersPerSections: [[ChannelPost]] = [[]]
    var selectedCategoryIndex = -1
    
//    let transition = MTransition()
//    let navTranstion = MNavigationTranstion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewType = ViewType.all
       //Rounding Story Button
        storyButton.layer.cornerRadius = storyButton.bounds.width / 2
        
        setupPicker()
        setupCollectionView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeChannelPosts()
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    // Retrieve the latest channel posts from Firebase
    func observeChannelPosts() {
        
        self.storiesList = [ChannelPost]()
        self.postList = [ChannelPost]()
        //To get all posts of Channel
        Api.ChannelPost.getAllChannelPosts(channelId: channelId) { (posts) in
            if posts.count == 0{
                self.noPostLabel.isHidden = false
                return
            }
            for channelPost in posts{
                
                self.noPostLabel.isHidden = true
                // Check and make sure channel post object is not already added into the postList (i.e. duplication) by checking if postId already exists in the array
                if !self.postList.contains(where: {$0.postId == channelPost.postId}) {
                    
                    let postDate = Date(timeIntervalSince1970: channelPost.datePosted)
                    let currDate = Date.init()
                    
                    let diffInDays = Calendar.current.dateComponents([.day], from: postDate, to: currDate).day
                    if diffInDays != nil{
                        if diffInDays! > 0{
                            // If not duplicate, then append to postList array
                            self.postList.append(channelPost)
                        }else{
                            // If not duplicate, then append to postList array
                            self.storiesList.append(channelPost)
                            //Set Story Image and Draw Border...
                            self.storyButton!.sd_setImage(with: URL.init(string: channelPost.imageUrl), for: .normal, completed:nil)
                        }
                    }
                }
            }

            // Sort posts by date
            self.sortPosts()
            self.storyView.drawBorder(withNumberOfDots: self.storiesList.count)
            
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
            if self.viewType == ViewType.category{
                self.categorisePosts()
            }
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
        
        // Add photo button to top right of header => REMOVED Because we don't need it in the Nav Bar anymore
//        let photoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(photoButtonDidTapped))
//        self.navigationItem.rightBarButtonItem = photoButton
        
    }
    
    //Bottom Camera Button Action
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.photoButtonDidTapped()
    }
    
    @IBAction func storyButtonTapped(_ sender: UIButton) {
        if storiesList.count == 0{
            self.photoButtonDidTapped()
        }else{
            self.performSegue(withIdentifier: "storiesVC", sender: nil)
        }
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
        if viewType == ViewType.category{
            return 1
        }
        return sortedUsersFirstLetters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.postList.count
        if viewType == ViewType.category{
            return categorisedPostList.count
        }
        return sortedUsersPerSections[section].count
    }
    
    // Load picture into each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewType == ViewType.category{
            
            switch categorisedPostList[indexPath.row].count{
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailSingleImageCollectionViewCell", for: indexPath) as! ChannelDetailSingleImageCollectionViewCell
                cell.loadData(categorisedPostList[indexPath.row])
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailsDoubleImageCollectionViewCell", for: indexPath) as! ChannelDetailsDoubleImageCollectionViewCell
                cell.loadData(categorisedPostList[indexPath.row])
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailsTrippleImageCollectionViewCell", for: indexPath) as! ChannelDetailsTrippleImageCollectionViewCell
                cell.loadData(categorisedPostList[indexPath.row])
                return cell
            case _ where categorisedPostList[indexPath.row].count >= 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailsQuadImageCollectionViewCell", for: indexPath) as! ChannelDetailsQuadImageCollectionViewCell
                cell.loadData(categorisedPostList[indexPath.row])
                return cell

            default:
                break
            }
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailCollectionViewCell", for: indexPath) as! ChannelDetailCollectionViewCell
        let channelPost = sortedUsersPerSections[indexPath.section][indexPath.row]
        cell.loadData(channelPost)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewType == ViewType.category{
            //showCategory
            selectedCategoryIndex = indexPath.row
            performSegue(withIdentifier: "showCategory", sender: nil)
            return
        }
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
        }else if segue.identifier == "showCategory"{
            let catDetailsVC = segue.destination as! CategoriesDetailsViewController
            catDetailsVC.categoryPosts = categorisedPostList[selectedCategoryIndex]
        }else if segue.identifier == "storiesVC"{
            let storyVC = segue.destination as! StoriesViewController
            storyVC.storiesList = self.storiesList
        }
    }
    
    // Specify width and height of each grid/cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if viewType == ViewType.category{
            //-20 for width is because of Spaces between cells. +20 for height is for the Category name label.
            return CGSize(width: view.frame.size.width/2 - 20, height: view.frame.size.width/2 + 20)
        }
        
        // Make each cell 1/4 of the screen size so we fit 4 per row (We - 1.5 because we want to make the space between each cell 0.5, of which therefore means a 1.5 as there're 3 gaps.)
        return CGSize(width: view.frame.size.width/4 - 1.5, height: view.frame.size.width/4 - 1.5)
    }
    
    // Specify space between each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if viewType == ViewType.category{
            return 10
        }
        
        return 2
    }
    
    // Specify space between each cell on the same row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if viewType == ViewType.category{
            return 5
        }
        return 1
    }
    
    // Section heading
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section > 0{
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChannelDetailSectionHeaderView", for: indexPath) as? ChannelDetailSectionHeaderView {
                
                if viewType == ViewType.all{
                    sectionHeader.dateLabel.text = sortedUsersFirstLetters[indexPath.section]
                    sectionHeader.viewAllButton.setTitle("View All ▼", for: .normal)
                }else{
                    sectionHeader.dateLabel.text = ""
                    sectionHeader.viewAllButton.setTitle("View Category ▼", for: .normal)
                }
                
                if indexPath.section == 0{
                    sectionHeader.viewAllButton.isHidden = false
                }else{
                    sectionHeader.viewAllButton.isHidden = true
                }
                
                sectionHeader.viewAllButton.addTarget(self, action: #selector(changeView(sender:)), for: .touchUpInside)
                
                return sectionHeader
            }
        }
        
        return UICollectionReusableView()
    }
    
    @objc func changeView(sender:UIButton){
        if viewType == ViewType.all{
            viewType = ViewType.category
            collectionViewTrailingConstraint.constant   = 15
            collectionViewLeadingConstraint.constant    = 15
            self.categorisePosts()
        }else{
            viewType = ViewType.all
            noCategoryView.isHidden = true
            collectionViewTrailingConstraint.constant   = 0
            collectionViewLeadingConstraint.constant    = 0
        }
        collectionView.reloadData()
    }
    
    func categorisePosts(){
        categorisedPostList = [[ChannelPost]]()
        let sorted = postList.sorted(by: { $0.category > $1.category })
        var lastCat = ""
        var lastIndex = -1
        for i in 0...sorted.count-1{
            let p = sorted[i]
            if p.category == ""{
                continue
            }
            if lastCat == "" || lastCat != p.category{
                categorisedPostList.append([p])
                lastIndex += 1
            }else{
                categorisedPostList[lastIndex].append(p)
            }
            lastCat = p.category
        }
        
        if categorisedPostList.count == 0 {
            noCategoryView.isHidden = false
        }else{
            noCategoryView.isHidden = true
        }
    }
}

// Handle image and camera picker
extension ChannelDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Handles when user finishes picking or taking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Extract image from selection/camera. The photo is extracted from 'info' dictionary response once user takes a picture or selects a picture from photo library
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage? {
            
            // Pass & set the previewVC image variable to the selected image
            let storyboard = UIStoryboard(name: "Channel", bundle: nil)
            let previewVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_PREVIEW) as! PreviewViewController
            previewVC.selectedImage = image
            previewVC.channelId = channelId
            previewVC.userIDList = userIDList
            previewVC.channelName = channelName
            
            // Get the top hierarchy VC and show the previewVC on top of it as a modal
            DispatchQueue.main.async {
                Utility().getTopMostViewController()?.present(previewVC, animated: true, completion: nil)
            }
            
        }
    }
}
