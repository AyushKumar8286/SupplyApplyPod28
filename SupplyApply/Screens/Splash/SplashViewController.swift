//
//  SplashViewController.swift
//  Deponet-Options
//
//  Created by Mac6 on 1/9/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import UIKit


class SplashViewController: UIViewController {
    
    var navigator: AppNavigator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigator = AppNavigator(navigationController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigateToNextScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func navigateToNextScreen(){
        if UserDefaults.standard.isLoggedIn(){
            navigator.navigateAndReplacePreviews(to: .dashboard)
        }else{
            navigator.navigateAndReplacePreviews(to: .login)
        }
    }
    
    
    
}
