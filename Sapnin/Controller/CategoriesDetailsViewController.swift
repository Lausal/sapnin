//
//  CategoriesDetailsViewController.swift
//  Sapnin
//
//  Created by Muhammad Burhan on 12/09/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

class CategoriesDetailsViewController: UIViewController {

    var categoryPosts : [ChannelPost]!
    var selectedPostId: String!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryPosts.first?.category
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension CategoriesDetailsViewController : PostCategoryUpdatedDelegate{
    
    func update(posts:[ChannelPost]){
        self.categoryPosts = posts
        self.collectionView.reloadData()
    }
    
}

extension CategoriesDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPosts.count
    }
    
    // Load picture into each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailCollectionViewCell", for: indexPath) as! ChannelDetailCollectionViewCell
        let channelPost = categoryPosts[indexPath.row]
        cell.loadData(channelPost)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPostId = categoryPosts[indexPath.row].postId
        performSegue(withIdentifier: "imageViewVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set the ImageViewController image variable to selected image on segue
        if segue.identifier == "imageViewVC" {
            let imageVC = segue.destination as! ImageViewController
            imageVC.postList = self.categoryPosts
            imageVC.selectedPostId = selectedPostId
            imageVC.delegate = self
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
    
    
    
}
