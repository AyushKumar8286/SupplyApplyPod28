//
//  FaqViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 27/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import WebKit

class FaqViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var faqInfo : GenericResponse?
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewWebView: UIWebView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getFaqInfo()
    }

    
    //MARK:- PRIVATE METHODS
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        if let html = faqInfo?.descrip {
            viewWebView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    private func getFaqInfo() {

        if SHRestClient.isConnectedToInternet() {

            self.showLoading(isLoading: true)
            
            SHRestClient.faq(completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.faqInfo = response
                        self.setUpView()
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

}
