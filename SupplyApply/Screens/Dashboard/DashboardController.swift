//
//  DashboardController.swift
//  SupplyApply
//
//  Created by Yashvir on 25/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class DashboardController: CustomViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectedCategoryImageview: UIImageView!
    @IBOutlet weak var selectedCategoryLabel: UILabel!
    @IBOutlet weak var browseLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var parentVC : AnimatedAppTabBar!
    
    var selectedCategory : Category! {
        didSet {
            if let item = selectedCategory {
                selectedCategoryLabel.text = item.name
                
                let options = ImageLoadingOptions(
                    placeholder: UIImage(named: "Image Icon"),
                    transition: .fadeIn(duration: 0.3)
                )
                let url = URL(string: item.thumb ?? "")!
                Nuke.loadImage(with: url, options: options, into: selectedCategoryImageview)
            }
        }
    }
    
    var categories : [Category] = [] {
        didSet {
            if categories.count > 0 {
                let item = categories[0]
                selectedCategory = item
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.getCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parentVC.getCartCount(customerId: UserDefaults.standard.getCutomerID())
    }
    
    func setupView(){
        
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        UserDefaults.standard.setShipIn(value: false)
        self.selectedCategoryLabel.text  = ""
        self.containerView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(browseCategory))
        tapGesture.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(tapGesture)
        
        if let flowLayout = categoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 20
        }
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView?.register(UINib(nibName: "CategoryViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryViewCell")
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    @objc func browseCategory() {
//        parentVC.navigator.navigate(to: .subCategories(category: selectedCategory))
        parentVC.navigator.navigate(to: .subCategories(category: selectedCategory, isCallFrom: "", wishlist: []))
    }
    
    func getCategories(){
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getCategories { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if let categories = response.category {
                        self.categories = categories
                        self.browseLabel.isHidden = false
                        self.categoriesCollectionView.reloadData()
                    } else {
//                        self.parentVC.showToast(message : "Failed to fetch categories", type: .failure)
                        self.view.makeToast("Failed fetch categories")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            }
        } else {
            self.showNoInternetWarning()
        }
    }
    
}

extension DashboardController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        cell.categoryItem = categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.categoriesCollectionView.frame.height * 0.75, height: self.categoriesCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryViewCell{
            self.selectedCategoryImageview.image = cell.categoryImageView.image
            self.selectedCategoryLabel.text = cell.categoryLabel.text
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var fixedIndex = 0
        if self.categories.count > 0 {
            let cellWidth = self.categoriesCollectionView.frame.height * 0.75
            let cellInset = self.categoriesCollectionView.frame.width / CGFloat(self.categories.count)
            let tempIndex = self.categoriesCollectionView.contentOffset.x / cellWidth
            fixedIndex = Int((self.categoriesCollectionView.contentOffset.x + (tempIndex * cellInset)) / cellWidth)
        }
        
        if let cell = categoriesCollectionView.cellForItem(at: IndexPath(row: Int(fixedIndex), section: 0)) as? CategoryViewCell{
            self.selectedCategory = cell.categoryItem
        }
        
    }
    
}
