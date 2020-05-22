//
//  SettingsController.swift
//  SupplyApply
//
//  Created by Yashvir on 25/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class SettingsController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var nameArray : [String]?
    var imageArray : [String]?
    var wishlistProducts : [Product] = []
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewTableView: UITableView!
    
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        getAllWishList()
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        viewTableView.register(UINib(nibName: "SettingTableCell", bundle: Bundle.main), forCellReuseIdentifier: "SettingTableCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        nameArray = ["Your Account","Your Order","Live Chat","Your Wish List","About Us","FAQ", "Notifications","Dark Mode", "SIGN OUT"]
        imageArray = ["user.pdf" ,"Your Orders.pdf" ,"chat.pdf" , "Your wishlist.pdf","aboutUs.pdf","faq.pdf","bell.png","lightbulb.png","sign out.pdf"]
    }
    
    private func getAllWishList() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let custId = UserDefaults.standard.getCutomerID()
            let params : [String: Any] = [
                "customer_id" : custId
            ]
            
            SHRestClient.getAllWishlist(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.wishlistProducts = response.products ?? []
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    private func signOut() {
    }
    
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension SettingsController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell") as! SettingsTableViewCell
        
        cell.selectionStyle = .none
        cell.lblName.text = nameArray?[indexPath.row]
        cell.imageview.image = UIImage(named: imageArray?[indexPath.row] ?? "")
        
        if indexPath.row == 7 {
            
            cell.btnToggle.isHidden = false
            cell.imageRightArrow.isHidden = true
            cell.constraintViewTop.constant = 0.0
            
        } else if indexPath.row == 8 {
            
            cell.btnToggle.isHidden = true
            cell.imageRightArrow.isHidden = false
            cell.constraintViewTop.constant = 70.0
            
        } else if indexPath.row == 9 {
            
            cell.btnToggle.isHidden = true
            cell.imageRightArrow.isHidden = true
            cell.constraintViewTop.constant = 0.0
            
        } else {
            
            cell.constraintViewTop.constant = 0.0
            cell.btnToggle.isHidden = true
            cell.imageRightArrow.isHidden = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            parentVC.navigator.navigate(to: .myAccount)
        } else if indexPath.row == 1 {
            parentVC.navigator.navigate(to: .myOrder)
        } else if indexPath.row == 2 {
            
        } else if indexPath.row == 3 {
            parentVC.navigator.navigate(to: .subCategories(category: Category(categoryID: "", name: "", count: "", thumb: "", backgroundColor: ""), isCallFrom: "Settings", wishlist: wishlistProducts))
        } else if indexPath.row == 4 {
            parentVC.navigator.navigate(to: .aboutUs)
        } else if indexPath.row == 5 {
            parentVC.navigator.navigate(to: .faq)
        } else if indexPath.row == 6 {
            parentVC.navigator.navigate(to: .notification)
        } else if indexPath.row == 7 {
            
        } else if indexPath.row == 8 {
            
        } else if indexPath.row == 9 {
            
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
