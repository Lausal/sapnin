//
//  ImageViewController.swift
//  Sapnin
//
//  Created by Alan Lau on 26/07/2019.
//  Copyright © 2019 lau. All rights reserved.
//

import UIKit

protocol PostCategoryUpdatedDelegate{
    
    func update(posts:[ChannelPost])
    
}

class ImageViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    
    var delegate : PostCategoryUpdatedDelegate!
    
    // Holds the list of post objects
    var postList = [ChannelPost]()
    var selectedImageNo = IndexPath()
    var selectedPostId: String!
    var previousIndex = -1
    var selectedCategoryIndex = -1
    var categoriesTableView : UITableView!
    
    var visualEffectView : UIVisualEffectView!
    
    var categoriesDataSource = ["🍔 Food",
        "🤣 Hilarious",
        "🍾 Partying",
        "🚴‍♂ Fitness",
        "🗺 Travels",
        "📸 Selfies",
        "👨‍🍳 Cooking",
        "👠 Style",
        "📚 Work",
        "💥 Lit",
        "🎾 Sport"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initializeCategoriesTableView()
        scrollToImage()

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleImageTap(sender:)))
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.addGestureRecognizer(tapGesture)
        collectionView.contentInsetAdjustmentBehavior = .never
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    
        if postList.count < 1{
            if let vcs = self.navigationController?.viewControllers{
                if vcs.count > 2{
                    if let thirdLastVC = vcs[vcs.count - 2] as? ChannelDetailViewController{
                        self.navigationController?.popToViewController(thirdLastVC, animated: true)
                    }
                }
            }
        }
        
        // Show tab bar when leaving the page
        self.tabBarController?.tabBar.isHidden = false
    }
    
    var isHidden = false{
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    @objc func handleImageTap(sender:UITapGestureRecognizer){
        
        if !bottomView.isHidden{
            bottomView.isHidden = true
            topView.isHidden = true
            isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationItem.setHidesBackButton(true, animated: false)
            collectionView.reloadData()
        }else{
            bottomView.isHidden = false
            topView.isHidden = false
            navigationController?.setNavigationBarHidden(false, animated: false)
            isHidden = false
            self.navigationItem.setHidesBackButton(false, animated: false)
            collectionView.reloadData()
        }
        
    }
    
    func initializeCategoriesTableView(){
        //Initializing Categories Tableview with Initial position out of the View
        categoriesTableView = UITableView.init(frame: CGRect.init(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - 120))
        categoriesTableView.layer.cornerRadius              = 5
        categoriesTableView.separatorInset                  = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        categoriesTableView.tableFooterView                 = UIView.init(frame: .zero)
        categoriesTableView.delegate                        = self
        categoriesTableView.dataSource                      = self
        categoriesTableView.isHidden                        = true
        categoriesTableView.showsVerticalScrollIndicator    = false
        self.view.addSubview(categoriesTableView)
    }
    
    func setTitle(userId:String){
        //
        Api.User.observeSpecificUserById(uid: userId) { (u) in
            self.title = u.name
        }
    }
    
    // Scroll to the selected image from the channel details page - This is called after view has laid everything out using view.layoutIfNeeded()
    func scrollToImage() {
        
        view.layoutIfNeeded()
        
        // Get the index of the selected post by finding the array index of matching ID
        let index = postList.index(where: { $0.postId == selectedPostId })
        setTitle(userId: postList[index!].ownerId)
        if postList[index!].category.count != 0{
            categoryButton.setImage(nil, for: .normal)
            selectedCategoryIndex = categoriesDataSource.index(of: postList[index!].category) ?? -1
            categoriesTableView.reloadData()
            categoryButton.setTitle(postList[index!].category.components(separatedBy: " ").first, for: .normal)
        }else{
            categoryButton.setImage(UIImage.init(named: "icon_categories"), for: .normal)
            categoryButton.setTitle("", for: .normal)
        }
        previousIndex = index!
        // Scroll to the selected image
        collectionView.scrollToItem(at: IndexPath(item: index!, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    // Set up the collectionview styling and interaction
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Set horizontal scroll
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        // Enable paging
        collectionView.isPagingEnabled = true
        
        // Hide pagination indicator
        collectionView.showsHorizontalScrollIndicator = false
        
        // Set background colour
        collectionView.backgroundColor = UIColor.black
        
        // Make collectionview full width to include the safe areas
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        
    }

    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        categoriesTableView.reloadData()
        categoriesTableView.isHidden = false
        var fr = categoriesTableView.frame
        fr.origin.y = 120
        UIView.animate(withDuration: 0.4) {
            self.categoriesTableView.frame = fr
            self.view.layoutIfNeeded()
        }
    }
}

extension ImageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = categoriesDataSource[indexPath.row]
        if indexPath.row == selectedCategoryIndex{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        cell.selectionStyle    = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView              = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 80))
        headerView.backgroundColor  = .white
        
        let capsuleLabel                = UILabel.init(frame: CGRect.init(x: (tableView.bounds.width / 2) - 25, y: 10, width: 50, height: 5))
        capsuleLabel.text               = ""
        capsuleLabel.backgroundColor    = .lightGray
        capsuleLabel.clipsToBounds      = true
        capsuleLabel.layer.cornerRadius = 2
        headerView.addSubview(capsuleLabel)
        
        let headerLabel             = UILabel.init(frame: CGRect.init(x: (tableView.bounds.width / 2) - 90, y: 25, width: 180, height: 30))
        headerLabel.textAlignment   = .center
        headerLabel.text            = "Categorise the snap"
        headerLabel.font            = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(headerLabel)
        
        let doneButton = UIButton.init(frame: CGRect.init(x: tableView.bounds.width - 75, y: 25, width: 50, height: 30))
        doneButton.setTitleColor(BrandColours.PINK, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped(sender:)), for: .touchUpInside)
        headerView.addSubview(doneButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCategoryIndex == indexPath.row{
            selectedCategoryIndex = -1
        }else{
            selectedCategoryIndex = indexPath.row
        }
        categoryButton.setImage(nil, for: .normal)
        categoryButton.setTitle(categoriesDataSource[indexPath.row].components(separatedBy: " ").first, for: .normal)
        if previousIndex != -1{
            postList[previousIndex].category = categoriesDataSource[indexPath.row]
        }
        
        self.categoriesTableView.reloadData()
    }
    
    @objc func doneButtonTapped(sender:UIButton){
        var fr = categoriesTableView.frame
        fr.origin.y = self.view.frame.height
        UIView.animate(withDuration: 0.4) {
            self.categoriesTableView.frame = fr
            self.view.layoutIfNeeded()
        }
        if selectedCategoryIndex == -1{
            return
        }
        
        Api.ChannelPost.updateChannelPostCategory(channelId: postList[previousIndex].channelId, postId: postList[previousIndex].postId, category: categoriesDataSource[selectedCategoryIndex])
        
        if postList[previousIndex].category != categoriesDataSource[selectedCategoryIndex]{
            postList.remove(at: previousIndex)
            if postList.count == 0{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        if delegate != nil{
            delegate.update(posts: postList)
        }
    }
    
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    // Load picture into each cell by passing each post object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let channelPost = self.postList[indexPath.item]
        cell.loadData(channelPost)
        
        if !bottomView.isHidden{
            cell.image.backgroundColor = .white
        }else{
            cell.image.backgroundColor = .black
        }
        
        
        return cell
    }
    
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
    
    // Set the collectionView as full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        return screenSize
    }
    
    // Set collectionview insets as 0 so it takes up full width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Set collectionView as no line between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // Set collectionView as no line between columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ImageViewController : UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage != previousIndex && postList.count - 1 > currentPage{
            setTitle(userId: postList[currentPage].ownerId)
            previousIndex = currentPage
        }
        
        if postList[currentPage].category.count != 0{
            categoryButton.setImage(nil, for: .normal)
            categoryButton.setTitle(postList[currentPage].category.components(separatedBy: " ").first, for: .normal)
        }else{
            categoryButton.setImage(UIImage.init(named: "icon_categories"), for: .normal)
            categoryButton.setTitle("", for: .normal)
        }
    }
}
