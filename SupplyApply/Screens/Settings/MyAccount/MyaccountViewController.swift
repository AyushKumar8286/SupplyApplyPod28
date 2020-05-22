//
//  MyaccountViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 28/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class MyaccountViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var accountList : MyAccountInfo?
    
    //MARK:- IBOUTLET
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtFieldaddress: UITextField!
    @IBOutlet weak var txtFieldUpdateLicense: UITextField!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnNewsletter: UIButton!
    @IBOutlet weak var lblTextCount: UILabel!
    
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountList()
    }
    
    
    //MARK:- PRIVATE METHODS
    private func setUpView() {
        
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        lblName.text = accountList?.accountInfo?.name
        lblEmail.text = accountList?.accountInfo?.email
        lblMobileNumber.text = accountList?.accountInfo?.phone
//        lblPassword.text = accountList?.accountInfo?.name
        txtFieldaddress.text = accountList?.accountInfo?.address?.address?.htmlToString
        txtFieldUpdateLicense.text = accountList?.accountInfo?.license
        let count = accountList?.accountInfo?.address?.address?.count
        lblTextCount.text = "\(count!) " + "/" + " 99"
    }
    
    private func getAccountList() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID()
            ]
            
            SHRestClient.accountInfo(params: params,completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.accountList = response
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
    
    
    @IBAction func clickedBtnEditAddress(_ sender: Any) {
        
        txtFieldaddress.isUserInteractionEnabled = true
        txtFieldaddress.becomeFirstResponder()
    }
    
    
    @IBAction func clickedBtnEditUpdateLi(_ sender: Any) {
        
        txtFieldUpdateLicense.isUserInteractionEnabled = true
        txtFieldUpdateLicense.becomeFirstResponder()
    }
    
    @IBAction func clickedBtnNotification(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            btnNotification.setImage(UIImage(named: "switch-on-toggle.pdf"), for: .normal)
        } else {
            btnNotification.setImage(UIImage(named: "switch-off_toggle.pdf"), for: .normal)
        }
    }
    
    @IBAction func clcikedBtnNewletter(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            btnNewsletter.setImage(UIImage(named: "switch-on-toggle.pdf"), for: .normal)
        } else {
            btnNewsletter.setImage(UIImage(named: "switch-off_toggle.pdf"), for: .normal)
        }
    }
}


