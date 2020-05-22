//
//  UIHelper.swift
//  Deponet-Options
//
//  Created by SunTec on 28/01/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

enum ToastType {
    case info
    case success
    case failure
}

class CustomViewController : UIViewController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate , NVActivityIndicatorViewable {
    
    var navigator: AppNavigator!
    
    override func viewDidLoad() {
        
//        navigationController?.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func showLoading(isLoading: Bool){
        if isLoading{
            if #available(iOS 11.0, *) {
                startAnimating(CGSize(width: view.frame.width/5,height: view.frame.width/5), message: nil, messageFont: nil, type: NVActivityIndicatorType.ballSpinFadeLoader, color: Colors.tint, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: 1, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
            } else {
                // Fallback on earlier versions
            }
        } else{
            stopAnimating()
        }
    }
    
    func showNoInternetWarning() {
        showAlert(title: "Ooooops!", message : Constants.no_internet)
    }
    
    
    func showAlert(title: String, message : String){
        
        if #available(iOS 11.0, *) {
            let attributedTitleString = NSAttributedString(string: title, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : Colors.tint ?? UIColor.darkGray
            ])
            let attributedMessageString = NSAttributedString(string: "\n\(message)\n", attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                NSAttributedString.Key.foregroundColor : Colors.label ?? UIColor.gray
            ])
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.setValue(attributedTitleString, forKey: "attributedTitle")
            alert.setValue(attributedMessageString, forKey: "attributedMessage")
            alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Colors.background ?? UIColor.white
            alert.view.tintColor = Colors.tint ?? UIColor.darkGray
            alert.view.layer.cornerRadius = 10
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)
            }

        } else {
            // Fallback on earlier versions
        }
    }
    
    func showAlertWithAction(title: String, message : String, action : @escaping ()->Void) {
        if #available(iOS 11.0, *) {
        let attributedTitleString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : Colors.tint ?? UIColor.darkGray
        ])
        
        let attributedMessageString = NSAttributedString(string: "\n\(message)", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : Colors.label ?? UIColor.gray
        ])
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(attributedTitleString, forKey: "attributedTitle")
        alert.setValue(attributedMessageString, forKey: "attributedMessage")
        alert.view.tintColor = Colors.tint ?? UIColor.darkGray
        alert.view.layer.cornerRadius = 10
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            action()
        }))
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
        }
    }
    
    
    func showAlertWithActions(title: String, message : String, positiveAction : @escaping ()->Void, negativeAction : @escaping ()->Void){
        if #available(iOS 11.0, *) {
        let attributedTitleString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : Colors.tint ?? UIColor.darkGray
        ])
        
        let attributedMessageString = NSAttributedString(string: "\n\(message)", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : Colors.label ?? UIColor.gray
        ])
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.setValue(attributedTitleString, forKey: "attributedTitle")
        alert.setValue(attributedMessageString, forKey: "attributedMessage")
        alert.view.tintColor = Colors.tint ?? UIColor.darkGray
        alert.view.layer.cornerRadius = 10
        
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: {
            _ in
            negativeAction()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            positiveAction()
        }))
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
        }
    }
    
//    func showToast(message : String, type: ToastType) {
//        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.safeAreaInsets.top + 70))
//        toastView.backgroundColor = Colors.background
//        toastView.alpha = 1.0
//         self.view.addSubview(toastView)
//
//        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.safeAreaInsets.top + 15, width: self.view.frame.width - 40, height: 40))
//        toastLabel.font = UIFont.systemFont(ofSize: 16)
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.numberOfLines = 0
//        toastLabel.adjustsFontSizeToFitWidth = true
//
//        toastView.addSubview(toastLabel)
//
//        switch type {
//        case .info:
//            toastLabel.textColor = Colors.label
//        case .success:
//            toastLabel.textColor = Colors.tint
//        case .failure:
//            toastLabel.textColor = UIColor.systemRed
//        }
//
//        toastView.addDesign(cornerRadius: 20, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
//
//        UIView.animate(withDuration: 1.5, delay: 1.5, options: .transitionCurlDown, animations: {
//            toastView.alpha = 0.0
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastView.removeDesign()
//            toastView.removeFromSuperview()
//        })
//    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let simpleOver = SimpleOver()
        simpleOver.popStyle = true
        return simpleOver
    }
    
    func addShadowToView(view : UIView) {
        
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.shadow?.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowColor = Colors.shadow?.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.cornerRadius = 8
    }
}

class SimpleOver: NSObject, UIViewControllerAnimatedTransitioning {
    
    var popStyle: Bool = false
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if popStyle {
            
            animatePop(using: transitionContext)
            return
        }
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let f = transitionContext.finalFrame(for: tz)
        let fOff = f.offsetBy(dx: f.width, dy: 55)
        tz.view.frame = fOff
        
        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                tz.view.frame = f
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 55)
        
        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fz.view.frame = fOffPop
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
}
