//
//  ShippingViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke
import Stripe

class ShippingViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var imageArray = ["icon-location.pdf","icon-delivery.pdf","icon-payment.pdf","icon-summary.pdf"]
    var shipAddList : [ShippingAddressList] = []
    var payAddList : [PaymentAddressList] = []
    var shippingList : [ShippingMethod] = []
    var paymentList : [PaymentMethod] = []
    var submitpaymentList : PaymentDataClass?
    var submitShipping : GenericResponse?
    var checkoutSuccess : GenericResponse?
    var count = 1
    var shippingMethodCode = ""
    var paymentMethodCode = ""
    var isShipMethod = true
    var customerContext : STPCustomerContext?
    var paymentContext : STPPaymentContext?
    var totalAmount : Int = 0
    var shippingAddressId = 0
    var btnPaymentOption : UIButton?
    var isLiveMode = false
    var stripeStatus = false
    var stripeId = ""
    var loading = false {
        didSet {
            if self.loading {
                self.showLoading(isLoading: true)
            } else {
                self.showLoading(isLoading: false)
            }
        }
    }
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewCollectionView: UICollectionView!
    @IBOutlet weak var viewCheckout: UIView!
    @IBOutlet weak var lblBillingName: UILabel!
    @IBOutlet weak var lblBillingEmail: UILabel!
    @IBOutlet weak var lblBillingStreet: UILabel!
    @IBOutlet weak var lblBillingTown: UILabel!
    @IBOutlet weak var lnlShipName: UILabel!
    @IBOutlet weak var lblShipEmail: UILabel!
    @IBOutlet weak var lblShipStreet: UILabel!
    @IBOutlet weak var lblShipTown: UILabel!
    @IBOutlet weak var viewBilling: UIView!
    @IBOutlet weak var viewShipping: UIView!
    @IBOutlet weak var constraintViewAdrressBottom: NSLayoutConstraint!
    @IBOutlet weak var viewBillingAddressContent: UIView!
    @IBOutlet weak var viewShippingAddressContent: UIView!
    @IBOutlet weak var tableViewShippingMethod: UITableView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewShippingMethod: UIView!
    @IBOutlet weak var constraintShipMethodHeight: NSLayoutConstraint!
    @IBOutlet weak var lblShippingMethod: UILabel!
    @IBOutlet weak var viewOrderSummary: UIView!
    @IBOutlet weak var viewTableViewOrderSummary: UITableView!
    @IBOutlet weak var viewScrollView: UIView!
    @IBOutlet weak var viewSuccessOrder: UIView!
    @IBOutlet weak var imgViewOrderPlaced: UIImageView!
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var lblTrackOrder: UILabel!
    @IBOutlet weak var viewAddressContinue: UIView!
    @IBOutlet weak var viewShippingContinue: UIView!
    
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        UserDefaults.standard.setShipIn(value: false)
    }
    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        parentVC.isComeFrom = "Checkout"
        viewAddress.isHidden = false
        viewShippingMethod.isHidden = true
        viewOrderSummary.isHidden = true
        parentVC.bottomBar.isHidden = true
        viewSuccessOrder.isHidden = true
        parentVC.constraintBottomBarHeight.constant = 0
        viewAddressContinue.clipsToBounds = true
        viewAddressContinue.layer.cornerRadius = viewAddressContinue.layer.bounds.height/2
        viewShippingContinue.clipsToBounds = true
        viewShippingContinue.layer.cornerRadius = viewAddressContinue.layer.bounds.height/2
        viewCollectionView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        viewCollectionView.clipsToBounds = false
        viewCollectionView.layer.masksToBounds = false
        viewCollectionView.register(UINib(nibName: "ShippingCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShippingCollectionViewCell")
        viewCollectionView.delegate = self
        viewCollectionView.dataSource = self
        tableViewShippingMethod.register(UINib(nibName: "ShippingMethodTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ShippingMethodTableViewCell")
        tableViewShippingMethod.delegate = self
        tableViewShippingMethod.dataSource = self
        viewCheckout.clipsToBounds = true
        viewCheckout.layer.cornerRadius = viewCheckout.bounds.height/2
        viewTableViewOrderSummary.register(UINib(nibName: "OrderDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderDetailTableViewCell")
        viewTableViewOrderSummary.register(UINib(nibName: "OrderCouponTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderCouponTableViewCell")
        viewTableViewOrderSummary.register(UINib(nibName: "OrderPriceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderPriceTableViewCell")
        viewTableViewOrderSummary.register(UINib(nibName: "OrderSubmitTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderSubmitTableViewCell")
        viewTableViewOrderSummary.register(UINib(nibName: "SelectPaymentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectPaymentTableViewCell")
        viewTableViewOrderSummary.delegate = self
        viewTableViewOrderSummary.dataSource = self
        addShadowToView(view: viewBillingAddressContent)
        addShadowToView(view: viewShippingAddressContent)
        getPaymentAddressList(customerId: UserDefaults.standard.getCutomerID())
        imgViewOrderPlaced.layer.masksToBounds = true
        imgViewOrderPlaced.layer.cornerRadius = imgViewOrderPlaced.layer.bounds.height/2
        UserDefaults.standard.setShipIn(value: true)
        parentVC.leftTopBarItem.addTarget(self, action: #selector(self.handleBackBarBtn), for: .touchUpInside)
    }
    
    private func getPaymentAddressList(customerId:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : customerId
            ]
            
            SHRestClient.getpaymentAddressList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.shipAddList = response.shippingAddress ?? []
                        self.payAddList = response.paymentAddress ?? []
                        self.shippingAddressId = Int(self.shipAddList[0].addressID ?? "") ?? 0
                        self.loadShippingAddressView()
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
    
    private func getShippingList(customerId:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID(),
                "shipping_address_id" : shipAddList
            ]
            
            SHRestClient.getShippingMethodList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.shippingList = response.shippingMethods ?? []
                        let height : CGFloat = CGFloat((170 * (self.shippingList.count)))
                        self.constraintShipMethodHeight.constant = height + 145
                        self.saveShippingMethod()
//                        self.tableViewShippingMethod.reloadData()
                        debugPrint(response)
                    } else {
                        self.view.makeToast(response.message)
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
    
    private func submitShippingMethods(customerId:String, shippingMethod : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID(),
                "shipping_method" : shippingMethod
            ]
            
            SHRestClient.submitShippingMethod(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.submitShipping = response
                        self.viewAddress.isHidden = true
                        self.viewShippingMethod.isHidden = false
                        self.loadShippingMethodView()
                        debugPrint(response)
                    } else {
                        self.view.makeToast(response.message)
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
    
    private func placeOrder() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
//            let params : [String: Any] = [
//                "customer_id" : UserDefaults.standard.getCutomerID(),
//                "coupon_code" : shippingMethod
//            ]
            
            SHRestClient.checkoutSuccess(completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.checkoutSuccess = response
                        self.loadSuccessView()
                        debugPrint(response)
                    } else {
                        self.view.makeToast(response.message)
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
    
    private func confirmPayment() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            //            let params : [String: Any] = [
            //                "customer_id" : UserDefaults.standard.getCutomerID(),
            //                "coupon_code" : shippingMethod
            //            ]
            
            SHRestClient.confirmPayment(completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.checkoutSuccess = response
                        self.view.makeToast(response.message)
                        self.placeOrder()
                        debugPrint(response)
                    } else {
                        self.view.makeToast(response.message)
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
    
    private func getPaymentMethods(customerId:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID()
            ]
            
            SHRestClient.getPaymentMethod(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.paymentList = response.paymentMethods ?? []
                        let height : CGFloat = CGFloat((170 * (self.paymentList.count)))
                        self.constraintShipMethodHeight.constant = height
                        self.savePaymentMethod()
//                        self.tableViewShippingMethod.reloadData()
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
    
    private func submitPaymentMethods(customerId:String, paymentmethod:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID(),
                "payment_method" : paymentmethod
            ]
            
            SHRestClient.submitPaymentMethod(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.submitpaymentList = response.data
                        self.totalAmount = Int(self.submitpaymentList?.completeTotal ?? 0)
                        self.viewTableViewOrderSummary.reloadData()
                        if self.paymentMethodCode == "stripepro" {
                            self.loadStripePayment()
                        }
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
    
    private func stripeConfirm(id:String, status:Bool, islivemode:Bool) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "id" : id,
                "status" : status,
                "isLiveMode" : islivemode
            ]
            
            SHRestClient.stripeConfirm(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.checkoutSuccess = response
                        self.placeOrder()
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
    
    
    
    func saveShippingMethod() {
        
        for i in 0..<(shippingList.count) {
            
            if shippingList[i].quote?.flat?.code == shippingMethodCode {
                shippingList[i].isSelected = true
            } else {
                shippingList[i].isSelected = false
            }
        }
        tableViewShippingMethod.reloadData()
    }
    
    func savePaymentMethod() {
        
        for i in 0..<(paymentList.count) {
            
            if paymentList[i].code == paymentMethodCode {
                paymentList[i].isSelected = true
            } else {
                paymentList[i].isSelected = false
            }
        }
        tableViewShippingMethod.reloadData()
    }
    
    @objc func handleBackBarBtn() {
        
        if count == 1 {
            self.parentVC.navigator.navigateOnDashboard(to: .cart)
            return
        }
    
        count = count - 1
        clickedContinue(count: &count)
    }
    
    func clickedContinue( count : inout Int) {
        
        
        if count == 1 {
            
            viewAddress.isHidden = false
            viewShippingMethod.isHidden = true
            viewOrderSummary.isHidden = true
            getPaymentAddressList(customerId: UserDefaults.standard.getCutomerID())
            
            //Shipping Method
        } else if count == 2 {
            
            isShipMethod = true
            viewAddress.isHidden = true
            viewShippingMethod.isHidden = false
            viewOrderSummary.isHidden = true
            loadShippingMethodView()
            
            //Payment Method
        } else if count == 3 {
            
            if shippingMethodCode == "" {
                self.view.makeToast("Select Shipping method to continue")
                count = 2
                return
            }
            viewAddress.isHidden = true
            viewShippingMethod.isHidden = false
            viewOrderSummary.isHidden = true
            isShipMethod = false
            self.submitShippingMethods(customerId: "", shippingMethod: shippingMethodCode)
            
            //Order Summary
        } else if count == 4 {
            
            if paymentMethodCode == "" {
                self.view.makeToast("Select payment method to continue")
                count = 3
                return
            }
            viewAddress.isHidden = true
            viewShippingMethod.isHidden = true
            viewOrderSummary.isHidden = false
            self.submitPaymentMethods(customerId: "", paymentmethod: paymentMethodCode)
            
        } else if count == 5 {
            count = 4
            return
        }
        viewCollectionView.reloadData()
    }
    
    func loadShippingAddressView() {
        
        lblBillingName.text = shipAddList.first?.firstname
        lblBillingEmail.text = shipAddList.first?.emailID
        lblBillingStreet.text = shipAddList.first?.address1
        lblBillingTown.text = shipAddList.first?.address?.htmlToString
        lnlShipName.text = shipAddList.first?.firstname
        lblShipEmail.text = shipAddList.first?.emailID
        lblShipStreet.text = shipAddList.first?.address1
        lblShipTown.text = shipAddList.first?.address?.htmlToString
    }
    
    func loadShippingMethodView() {
        
        if isShipMethod {
            getShippingList(customerId: "")
            lblShippingMethod.text = "Select Shipping Method"
        } else {
            getPaymentMethods(customerId: "")
            lblShippingMethod.text = "Select Payment Method"
        }
    }
    
    func loadSuccessView() {
    
        viewScrollView.isHidden = true
        viewCollectionView.isHidden = true
        viewShippingMethod.isHidden = true
        viewOrderSummary.isHidden = true
        viewSuccessOrder.isHidden = false
        lblTrackOrder.text = checkoutSuccess?.message?.htmlToString
        self.parentVC.topBar.isHidden = true
        self.parentVC.constraintTopBarHeight.constant = 0
        imgViewOrderPlaced.layer.masksToBounds = true
        imgViewOrderPlaced.layer.cornerRadius = imgViewOrderPlaced.layer.bounds.height/2
    }
    
    func loadStripePayment() {
        
        let config = STPPaymentConfiguration.shared()
        config.additionalPaymentOptions = .applePay
        config.shippingType = .shipping
        config.requiredShippingAddressFields = nil
        config.companyName = "Testing XYZ"
        customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        paymentContext =  STPPaymentContext(customerContext: customerContext!, configuration: config, theme: .default())
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.paymentContext?.paymentAmount = 5000
    }
    
    //MARK:- IBACTION METHODS
    
    @IBAction func clickedBtnShipAndBillSame(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            viewBilling.isHidden = false
            viewShipping.isHidden = true
            constraintViewAdrressBottom.constant = -100
        } else {
            viewBilling.isHidden = false
            viewShipping.isHidden = false
            constraintViewAdrressBottom.constant = 20
        }
    }
    
    
    @IBAction func clickedBtnBillingAddress(_ sender: Any) {
        UserDefaults.standard.setisCallfor(value: "Billing")
        self.parentVC.navigator.navigate(to: .addAddress(addressid: shipAddList.first?.addressID ?? "", isFor: "Billing"))
    }
    
    
    @IBAction func clickedBtnShippingAddress(_ sender: Any) {
        UserDefaults.standard.setisCallfor(value: "Shipping")
        self.parentVC.navigator.navigate(to: .addAddress(addressid: shipAddList.first?.addressID ?? "", isFor: "Shipping"))
    }
    
    @IBAction func clickedBtnTrackOrder(_ sender: Any) {
        
        self.parentVC.navigator.navigateOnDashboard(to: .myOrder)
    }
    
    @IBAction func btnAddressContinue(_ sender: Any) {
        count = count + 1
        clickedContinue(count: &count)
    }
    
    
    @IBAction func btnShippingContinue(_ sender: Any) {
        count = count + 1
        clickedContinue(count: &count)
    }
}

//MARK:- COLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS

extension ShippingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShippingCollectionViewCell", for: indexPath) as! ShippingCollectionViewCell
        
        cell.viewContent.clipsToBounds = true
        cell.viewContent.layer.cornerRadius = cell.layer.bounds.size.height/2
        cell.imageViewTopBar.image = UIImage(named: imageArray[indexPath.row])
        
        if (count - 1) == indexPath.row {
            cell.viewContent.backgroundColor = Colors.hexColor(hex: "#F2A7BB")
            cell.imageViewTopBar.tintColor = UIColor.white
        } else {
            cell.viewContent.backgroundColor = UIColor.white
            cell.imageViewTopBar.tintColor = Colors.tint
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: viewCollectionView.layer.bounds.width/4 - 10, height: viewCollectionView.layer.bounds.height)
    }
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension ShippingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if tableView == tableViewShippingMethod {
            
            if isShipMethod {
                if ((shippingList.count)%2) == 0 {
                    count = ((shippingList.count)/2)
                } else {
                    count = (((shippingList.count) - 1)/2) + 1
                }
            } else {
                if ((paymentList.count)%2) == 0 {
                    count = ((paymentList.count)/2)
                } else {
                    count = (((paymentList.count) - 1)/2) + 1
                }
            }
        } else if tableView == viewTableViewOrderSummary {
            
            count = ((submitpaymentList?.products?.count ?? 0) + 4)
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        if tableView == tableViewShippingMethod {
            
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "ShippingMethodTableViewCell") as! ShippingMethodTableViewCell
            cell4.selectionStyle = .none
            cell4.delegate = self
            
            //Shipping Method
            if isShipMethod {
                
                cell4.imageViewTop.image = UIImage(named: "icon-delivery.pdf")
                cell4.lblFlatCost1.text = shippingList[indexPath.row * 2].quote?.flat?.cost
                let cost1 = shippingList[indexPath.row * 2].quote?.flat?.text ?? ""
                cell4.lblFlateRate1.text = shippingList[indexPath.row * 2].title ?? "" + "-" + cost1
                if shippingList[indexPath.row * 2].isSelected {
                    cell4.imageViewSelect1.isHidden = false
                } else {
                    cell4.imageViewSelect1.isHidden = true
                }
                
                if ((((shippingList.count)%2) != 0) && (indexPath.row*2 + 1 == shippingList.count)) {
                    cell4.viewRight.isHidden = true
                } else {
                    cell4.viewRight.isHidden = false
                    cell4.lblFlatCost2.text = shippingList[(indexPath.row * 2) + 1].quote?.flat?.cost
                    let cost2 = shippingList[(indexPath.row * 2) + 1].quote?.flat?.text ?? ""
                    cell4.lblFlateRate2.text = shippingList[(indexPath.row * 2) + 1].title ?? "" + "-" + cost2
                    if shippingList[(indexPath.row * 2) + 1].isSelected {
                        cell4.imageViewSelect2.isHidden = false
                    } else {
                        cell4.imageViewSelect2.isHidden = true
                    }
                }
               
                cell = cell4
                
            //Payment Method
            } else {
                
                cell4.imageViewTop.image = UIImage(named: "icon-payment.pdf")
                cell4.lblFlatCost1.text = paymentList[indexPath.row * 2].title
                cell4.lblFlateRate1.text = paymentList[indexPath.row * 2].code
                if paymentList[indexPath.row * 2].isSelected {
                    cell4.imageViewSelect1.isHidden = false
                } else {
                    cell4.imageViewSelect1.isHidden = true
                }
                if ((((paymentList.count)%2) != 0) && (indexPath.row*2 + 1 == paymentList.count)) {
                    cell4.viewRight.isHidden = true
                    
                } else {
                    cell4.viewRight.isHidden = false
                    cell4.lblFlatCost2.text = paymentList[(indexPath.row * 2) + 1].title
                    cell4.lblFlateRate2.text = paymentList[(indexPath.row * 2) + 1].code
                    if paymentList[(indexPath.row * 2) + 1].isSelected {
                        cell4.imageViewSelect2.isHidden = false
                    } else {
                        cell4.imageViewSelect2.isHidden = true
                    }
                }
                
               cell = cell4
            }
        } else if tableView == viewTableViewOrderSummary {
            
            if indexPath.row == ((submitpaymentList?.products?.count ?? 0) + 1) {
                
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "OrderPriceTableViewCell") as! OrderPriceTableViewCell
                
                cell1.lblSubTotal.text = submitpaymentList?.totals?[0].title
                cell1.lblSubTotalPrice.text = submitpaymentList?.totals?[0].text
                cell1.lblFlatShipping.text = submitpaymentList?.totals?[1].title
                cell1.lblFlatShippingRate.text = submitpaymentList?.totals?[1].text
                cell1.lblTotal.text = submitpaymentList?.totals?[2].title
                cell1.lblTotalRate.text = submitpaymentList?.totals?[2].text
                cell1.lblTotalPriceRate.text = "\(submitpaymentList?.completeTotal ?? 0)"
                
                cell1.selectionStyle = .none
                cell = cell1
                
            } else if indexPath.row == ((submitpaymentList?.products?.count ?? 0)) {
                
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "OrderCouponTableViewCell") as! OrderCouponTableViewCell
                cell2.selectionStyle = .none
                cell2.delegate = self
                cell = cell2
                
            } else if indexPath.row == ((submitpaymentList?.products?.count ?? 0) + 3) {
                
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "OrderSubmitTableViewCell") as! OrderSubmitTableViewCell
                cell3.selectionStyle = .none
                cell3.delegate = self
                cell = cell3
                
            } else if indexPath.row == ((submitpaymentList?.products?.count ?? 0) + 2) {
            
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "SelectPaymentTableViewCell") as! SelectPaymentTableViewCell
                if paymentMethodCode == "stripepro" {
                    cell4.isHidden = false
                } else {
                    cell4.isHidden = true
                }
                btnPaymentOption = cell4.btnPayfrom
                cell4.selectionStyle = .none
                cell4.delegate = self
                cell = cell4
                
            } else {
                
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell") as! OrderDetailTableViewCell
                cell4.lblProductName.text = submitpaymentList?.products?[indexPath.row].name
                cell4.lblSerialNumber.text = submitpaymentList?.products?[indexPath.row].model
                cell4.lblPrice.text = submitpaymentList?.products?[indexPath.row].price
                cell4.selectionStyle = .none
                
                let option = ImageLoadingOptions(
                    placeholder: UIImage(named: "Image Icon"),
                    transition: .fadeIn(duration: 0.0)
                )
                let url = URL(string: submitpaymentList?.products?[indexPath.row].href ?? "")!
                Nuke.loadImage(with: url, options: option, into: cell4.imgViewProduct)
                
                cell = cell4
            }
        }
        
        return cell ?? UITableViewCell()
    }
}

//MARK:- DealTableViewDelegate
extension ShippingViewController : ShippingMethodViewDelegate {
    
    func clickedBtnShipMethod1(cell: ShippingMethodTableViewCell, sender: UIButton) {
        
        //Shipping Method
        if isShipMethod {
            let indexpath = tableViewShippingMethod.indexPath(for: cell)
            for i in 0..<(shippingList.count){
                if ((indexpath?.row ?? 0) * 2) == i {
                    shippingList[i].isSelected = true
                    shippingMethodCode = shippingList[i].quote?.flat?.code ?? ""
                } else {
                    shippingList[i].isSelected = false
                }
            }
            tableViewShippingMethod.reloadData()
            
            
        //Payment Method
        } else {
            let indexpath = tableViewShippingMethod.indexPath(for: cell)
            for i in 0..<(paymentList.count){
                if ((indexpath?.row ?? 0) * 2) == i {
                    paymentList[i].isSelected = true
                    paymentMethodCode = paymentList[i].code ?? ""
                } else {
                    paymentList[i].isSelected = false
                }
            }
            tableViewShippingMethod.reloadData()
        }
    }
    
    func clickedBtnShipMethod2(cell: ShippingMethodTableViewCell, sender: UIButton) {
        
        //Shipping Method
        if isShipMethod {
            
            let indexpath = tableViewShippingMethod.indexPath(for: cell)
            for i in 0..<(shippingList.count){
                if (((indexpath?.row ?? 0) * 2) + 1) == i {
                    shippingList[i].isSelected = true
                    shippingMethodCode = shippingList[i].quote?.flat?.code ?? ""
                } else {
                    shippingList[i].isSelected = false
                }
            }
            tableViewShippingMethod.reloadData()
            
            //Payment Method
        } else {
            
            let indexpath = tableViewShippingMethod.indexPath(for: cell)
            for i in 0..<(paymentList.count){
                if (((indexpath?.row ?? 0) * 2) + 1) == i {
                    paymentList[i].isSelected = true
                    paymentMethodCode = paymentList[i].code ?? ""
                } else {
                    paymentList[i].isSelected = false
                }
            }
            tableViewShippingMethod.reloadData()
        }
    }
}

//MARK:- OrderCouponViewDelegate
extension ShippingViewController: OrderCouponViewDelegate {
    
    func clickedBtnDelete(cell: OrderCouponTableViewCell) {
        
        cell.txtFieldCoupon.text = ""
        cell.txtFieldCoupon.placeholder = "Coupon code"
    }
}

//MARK:- OrderCouponViewDelegate
extension ShippingViewController: SelectPaymentViewDelegate {
    
    func clickedBtnSelectPayment(cell: SelectPaymentTableViewCell) {
        self.paymentContext?.presentPaymentOptionsViewController()
    }
}

//MARK:- OrderSubmitViewDelegate
extension ShippingViewController: OrderSubmitViewDelegate {
    
    func clickedBtnSubmit(cell: OrderSubmitTableViewCell) {
        
        if paymentMethodCode == "stripepro" {
            
            if btnPaymentOption?.title(for: .normal) == "Select Payment Option" {
                self.view.makeToast("Please select any payment option")
                return
            }
            self.paymentContext?.requestPayment()
            
        } else if paymentMethodCode == "pp_standard" {            
            self.view.makeToast("Please select other payment method")
        } else if paymentMethodCode == "cod" {
            self.confirmPayment()
        }
    }
}

//MARK:- STPPaymentContextDelegate
extension ShippingViewController : STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        self.loading = paymentContext.loading
        if let paymentOption = paymentContext.selectedPaymentOption {
            btnPaymentOption?.setTitle(paymentOption.label, for: .normal)
        } else {
            btnPaymentOption?.setTitle("Select Payment Option", for: .normal)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        self.showLoading(isLoading: true)
        MyAPIClient.sharedClient.createPaymentIntent(customerId: "29", amount: "500", paymentMethodId: paymentResult.paymentMethod?.stripeId ?? "", completion: { (response) in
            switch response {
            case .success(let clientSecret):
                // Assemble the PaymentIntent parameters
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                paymentIntentParams.paymentMethodParams = paymentResult.paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    
                    self.showLoading(isLoading: false)
                    switch status {
                    case .succeeded:
                        self.stripeId = "\(paymentIntent?.stripeId ?? "")"
                        self.isLiveMode = Bool(paymentIntent?.livemode ?? false)
                        self.stripeStatus = true
                        completion(.success, nil)
                        
                    case .failed:
                        completion(.error, error) // Report error
                    case .canceled:
                        completion(.userCancellation, nil) // Customer cancelled
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            case .failure(let error):
                completion(.error, error) // Report error from your API
                break
            }
        })
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        switch status {
        case .error:
            self.view.makeToast(error.debugDescription)
        case .success:
            print("success")
            self.stripeConfirm(id: stripeId, status: stripeStatus, islivemode: isLiveMode)
        case .userCancellation:
            self.view.makeToast("Payment Cancled")
        default:
            print("default")
        }
    }
}
