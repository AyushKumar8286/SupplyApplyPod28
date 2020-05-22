//
//  AnimatedAppTabBar.swift
//  SupplyApply
//
//  Created by Yashvir on 12/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class AnimatedAppTabBar: CustomViewController {

    @IBOutlet weak var topSafeAreaView: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var bottomSafeArea: UIView!    
    @IBOutlet weak var leftTopBarItem: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTopBarItem: UIButton!
    @IBOutlet weak var bottomItemsStack: UIStackView!
    @IBOutlet weak var homeButtonIcon: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var quickShopButton: UIView!
    @IBOutlet weak var storeButton: BadgeButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var constraintTopBarHeight: NSLayoutConstraint!
    @IBOutlet weak var btnDealOfTheDay: UIButton!
    @IBOutlet weak var constraintBottomBarHeight: NSLayoutConstraint!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewSortBackground: UIView!
    
    
    var isDesigner : Bool!
    var titleString : String!
    var childVC : UIViewController!
    var cartCountResponse : GenericResponse?
    var isComeFrom : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
        getCartCount(customerId: UserDefaults.standard.getCutomerID())
    }
    
    func setupViews(){
        
        btnDealOfTheDay.setImage(UIImage(named: "icon-quick-shop.pdf"), for: .normal)
        viewError.isHidden = true
        titleLabel.text = titleString ?? ""
        viewSortBackground.isHidden = true
        
        if let vc = childVC {
            addChild(vc)
            vc.view.frame = containerView.frame
            vc.view.translatesAutoresizingMaskIntoConstraints = false

            self.containerView.addSubview(vc.view)

            NSLayoutConstraint.activate([
                vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])

            vc.didMove(toParent: self)
        }
        
        
        leftTopBarItem.isHidden = !self.navigator.canPop()
        
        if isDesigner {
            topBar.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            containerView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        } else {
            topBar.removeDesign()
            containerView.removeDesign()
        }
        
        topBar.clipsToBounds = false
        topBar.layer.masksToBounds = false
    }
    
    func getCartCount(customerId : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "customer_id" : customerId
            ]
            
            SHRestClient.getCartCount(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.cartCountResponse = response
                        self.storeButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
                        self.storeButton.badge = "\(self.cartCountResponse?.count! ?? 0)"
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    @IBAction func leftTopBarTapped(_ sender: Any) {
        
        if UserDefaults.standard.isShipIn() == true {
            return
        }
        self.navigator.pop()
    }
    
    @IBAction func dashboardSelected(_ sender: Any) {
        if navigator.canPop() {
            self.navigator.navigateToDashboard()
        }
    }
    
    @IBAction func chatSelected(_ sender: Any) {
        self.navigator.navigateOnDashboard(to: .chat)
    }
    
    @IBAction func quickShopSelected(_ sender: Any) {
        btnDealOfTheDay.setImage(UIImage(named: "icon-quick-shop cross.pdf"), for: .normal)
        self.navigator.navigateOnDashboard(to: .dealoftheDay)
    }
    
    @IBAction func cartSelected(_ sender: Any) {
        self.navigator.navigateOnDashboard(to: .cart)
    }
    
    @IBAction func settingsSelected(_ sender: Any) {
        self.navigator.navigateOnDashboard(to: .settings)
    }
    
    @IBAction func clickedBtnSearch(_ sender: Any) {
        self.navigator.navigate(to: .search)
    }
}
