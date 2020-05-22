//
//  Navigator.swift
//  Deponet-Options
//
//  Created by Mac6 on 1/9/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation
import UIKit

protocol ExitControllerDelegate {
    func shouldPop()->Void
}

protocol Navigator {
    associatedtype Destination
    func navigate(to destination: Destination)
}

class AppNavigator : Navigator {
    
    enum Destination {
        case login
        case signup
        case licenseValidate(customerId: String, delegate: UIViewController?)
        case forgotPassword
        case dashboard
        case subCategories(category: Category, isCallFrom : String, wishlist : [Product])
        case chat
        case cart
        case settings
        case productInfo(productName: String, productId: String)
        case productImage(productName: String, productModel: String, productImage : String)
        case faq
        case aboutUs
        case myAccount
        case myOrder
        case dealoftheDay
        case search
        case shipping
        case addAddress(addressid: String, isFor: String)
        case searchProduct(search: String)
        case notification
    }
    
    
    // In most cases it's totally safe to make this a strong
    // reference, but in some situations it could end up
    // causing a retain cycle, so better be safe than sorry :)
    private weak var navigationController: UINavigationController?
    
    // MARK: - Initializer
    init(navigationController : UIViewController) {
        if let nav = navigationController.navigationController{
            self.navigationController = nav
        }
    }
    
    func canPop() -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popWithoutAnimation() {
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Navigator
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateWithoutAnimation(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func navigateAndReplacePreviews(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.viewControllers.removeAll()
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func navigateToDashboard() {
        navigationController?.popToRootViewController(animated: false)
    }
    
//    func navigateOnDashboard(to destination: Destination) {
//        let viewController = makeViewController(for: destination)
//        let viewControllersCount = (navigationController?.viewControllers.count ?? 0) - 1
//        if viewControllersCount > 0 {
//            for index in 0...viewControllersCount {
//                if index > 0 {
//                    navigationController?.viewControllers.remove(at: index)
//                }
//            }
//        }
//        navigationController?.pushViewController(viewController, animated: false)
//    }
    
    func navigateOnDashboard(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        let viewControllersCount = (navigationController?.viewControllers.count ?? 0) - 1
        let count = 1
        if viewControllersCount > 0 {
            for _ in 0...viewControllersCount - 1 {
                navigationController?.viewControllers.remove(at: count)
            }
        }
        
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Private
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .login:
            let vc = LoginViewController()
            vc.navigator = self
            return vc
        case .signup:
            let vc = SignUpViewController()
            vc.navigator = self
            return vc
        case .licenseValidate(let customerId, let delegate):
            let vc = LicenseValidationController()
            vc.navigator = self
            vc.customerId = customerId
            vc.delegate = (delegate != nil) ? (delegate as! ExitControllerDelegate) : nil
            return vc
        case .forgotPassword:
            let vc = ForgotPasswordViewController()
            vc.navigator = self
            return vc
        case .dashboard:
            return addChildToAppTabBar(childVc: DashboardController(), title: "Store", isDesigner: false)
        case .subCategories(let category, let isCallFrom, let wishlist):
            let childVC = SubCategoryController()
            
            if isCallFrom == "Settings" {
                childVC.category = category
                childVC.iscallFrom = "Settings"
                return addChildToAppTabBar(childVc: childVC, title: "Your Wish List", isDesigner: true)
            } else {
                childVC.category = category
                childVC.wishlistProducts = wishlist
                return addChildToAppTabBar(childVc: childVC, title: category.name ?? "", isDesigner: true)
            }
        case .chat:
            return addChildToAppTabBar(childVc: ChatController(), title: "Chat", isDesigner: true)
        case .cart:
            return addChildToAppTabBar(childVc: CartController(), title: "Cart", isDesigner: true)
        case .settings:
            return addChildToAppTabBar(childVc: SettingsController(), title: "Settings", isDesigner: true)
        case .productInfo(let productName, let productId):
            let childVC = ProductListController()
            childVC.productName = productName
            childVC.productId = productId
            return addChildToAppTabBar(childVc: ProductListController(), title: productName, isDesigner: true)
        case .productImage(let productName,let productModel,let productImage) :
            let childVC = ImageViewController()
            childVC.productname = productName
            childVC.productmodel = productModel
            childVC.productimage = productImage
            return addChildToAppTabBar(childVc: childVC, title: "", isDesigner: false)
        case .faq :
            return addChildToAppTabBar(childVc: FaqViewController(), title: "FAQ", isDesigner: true)
        case .aboutUs :
            return addChildToAppTabBar(childVc: AboutUsViewController(), title: "About us", isDesigner: true)
        case .myAccount :
            return addChildToAppTabBar(childVc: MyaccountViewController(), title: "Your Account", isDesigner: true)
        case .myOrder :
            return addChildToAppTabBar(childVc: MyOrderViewController(), title: "Your Orders", isDesigner: true)
        case .dealoftheDay :
            return addChildToAppTabBar(childVc: DealoftheDayViewController(), title: "Deal Of The Day", isDesigner: false)
        case .search :
            return addChildToAppTabBar(childVc: SearchViewController(), title: "Search", isDesigner: false)
        case .shipping :
            return addChildToAppTabBar(childVc: ShippingViewController(), title: "Delivery Address", isDesigner: false)
        case .addAddress(let addressid, let isFor) :
            let childVC = AddAddressViewController()
            if isFor == "Shipping" {
                UserDefaults.standard.setShipAddressId(value: addressid)
            } else if isFor == "Billing" {
                UserDefaults.standard.setBillAddressId(value: addressid)
            }
            return addChildToAppTabBar(childVc: childVC, title: "Shipping Address", isDesigner: false)
        case .searchProduct(let search) :
            return addChildToAppTabBar(childVc: SearchProductViewController(), title: search, isDesigner: false)
        case .notification :
            return addChildToAppTabBar(childVc: NotificationViewController(), title: "Notifications", isDesigner: true)
        }
    }
    
    func addChildToAppTabBar(childVc : UIViewController, title: String, isDesigner : Bool) -> UIViewController {
        let vc = AnimatedAppTabBar()
        vc.navigator = self
        vc.titleString = title
        vc.isDesigner = isDesigner
        vc.childVC = childVc
        return vc
    }
    
}
