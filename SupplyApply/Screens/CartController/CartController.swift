//
//  CartController.swift
//  SupplyApply
//
//  Created by Yashvir on 25/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class CartController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var cartList : CartListModel?
    var productquantity = 1
    var editCartResponse : GenericResponse?
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewTableView: UITableView!
    
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        viewTableView.register(UINib(nibName: "CartDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartDetailTableViewCell")
        viewTableView.register(UINib(nibName: "CartPriceListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartPriceListTableViewCell")
        viewTableView.register(UINib(nibName: "CartCheckoutTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartCheckoutTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        getCartList()
    }
    
    
    private func getCartList() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let custId = UserDefaults.standard.getCutomerID()
            
            let params : [String: Any] = [
                "customer_id" : custId
            ]
            
            SHRestClient.getCartList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.cartList = response
                        self.viewTableView.reloadData()
                        debugPrint(response)
                    } else {
                        self.parentVC.viewError.isHidden = false
                        self.parentVC.lblError.text = response.message
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
    
    private func editCartList(cartId : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "quantity[\(cartId)]" : productquantity
            ]
            
            SHRestClient.editCartList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.editCartResponse = response
                        self.getCartList()
//                        self.parentVC.showToast(message: response.message ?? "", type: .info)
                        self.view.makeToast(response.message ?? "")
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
    
    private func deleteCartList(customerId : String , cartId : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let custId = UserDefaults.standard.getCutomerID()
            
            let params : [String: Any] = [
                "key" : cartId ,
                "customer_id" : custId
            ]
            
            SHRestClient.deleteCartList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.editCartResponse = response
//                        self.parentVC.showToast(message: response.message ?? "", type: .info)
                        self.view.makeToast(response.message ?? "")
                        self.getCartList()
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
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension CartController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((cartList?.products?.count ?? 0) + 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        if indexPath.row == ((cartList?.products?.count ?? 0)) {
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartPriceListTableViewCell") as! CartPriceListTableViewCell
            
            cell1.cartlist = cartList
            cell1.priceTotal = cartList?.totals?.count ?? 0
            cell1.selectionStyle = .none
            cell1.viewTableView.reloadData()
            cell = cell1
            
        } else if indexPath.row == ((cartList?.products?.count ?? 0) + 1){
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CartCheckoutTableViewCell") as! CartCheckoutTableViewCell
            cell2.selectionStyle = .none
            cell2.delegate = self
            cell = cell2
            
        } else {
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "CartDetailTableViewCell") as! CartDetailTableViewCell
            cell3.lblProductName.text = cartList?.products?[indexPath.row].name
            cell3.lblSerialNumber.text = cartList?.products?[indexPath.row].model
            cell3.lblPrice.text = cartList?.products?[indexPath.row].price
            cell3.lblTotalPrice.text = cartList?.products?[indexPath.row].total
            cell3.lblQuantity.text = cartList?.products?[indexPath.row].quantity
            cell3.selectionStyle = .none
            cell3.delegate = self
            
            let option = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            let url = URL(string: cartList?.products?[indexPath.row].thumb ?? "")!
            Nuke.loadImage(with: url, options: option, into: cell3.imageProduct)
            
            cell = cell3
        }
        
        return cell ?? UITableViewCell()
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == ((cartList?.products?.count ?? 0)) {
            
            return CGFloat(50*((cartList?.totals?.count ?? 0)))
        } else {
            return UITableView.automaticDimension
        }
        
        
//        return UITableView.automaticDimension
    }
}

//MARK:- CartDetailViewDelegate DELEGATE METHODS

extension CartController : CartDetailViewDelegate {
    
    func clickedBtnImage(cell: CartDetailTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productname = cartList?.products?[indexpath?.row ?? 0].name ?? ""
        let productmodel = cartList?.products?[indexpath?.row ?? 0].model ?? ""
        let productimage = cartList?.products?[indexpath?.row ?? 0].thumb ?? ""        
        parentVC.navigator.navigate(to: .productImage(productName: productname, productModel: productmodel, productImage: productimage))
    }
    
    func clickedbtnPlus(cell: CartDetailTableViewCell) {
        
        cell.lblQuantity.text = String((Int(cell.lblQuantity.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.lblQuantity.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus(cell: CartDetailTableViewCell) {
        
        if ((Int(cell.lblQuantity.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.lblQuantity.text = String((Int(cell.lblQuantity.text ?? "") ?? 0) - 1)
        }
        productquantity = (Int(cell.lblQuantity.text ?? "") ?? 0)
    }
    
    func clickedBtnRefresh(cell: CartDetailTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let cartid = cartList?.products?[indexpath?.row ?? 0].cartID ?? ""
        
        if cell.lblQuantity.text == cartList?.products?[indexpath?.row ?? 0].quantity {
//            parentVC.showToast(message: "No Quantity change detected!. Please update the quantity", type: .info)
            self.view.makeToast("No Quantity change detected!. Please update the quantity")
        } else {
            
            parentVC.showAlertWithAction(title: "", message: "To Update quantity of this product please confirm") {
                self.editCartList(cartId : cartid)
            }
        }
    }
    
    func clickedBtnDelete(cell: CartDetailTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let cartid = cartList?.products?[indexpath?.row ?? 0].cartID ?? ""
        self.deleteCartList(customerId: "", cartId: cartid)
    }
    
    func clickedBtnProductName(cell: CartDetailTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = cartList?.products?[indexpath?.row ?? 0].productID ?? ""
        let productname = cartList?.products?[indexpath?.row ?? 0].name ?? ""
        UserDefaults.standard.setProductID(value: productid)
        UserDefaults.standard.setProductName(value: productname)
        parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
}

//MARK:- CartCheckoutViewDelegate DELEGATE METHODS

extension CartController : CartCheckoutViewDelegate {
    
    func clickedCheckoutBtn() {
        self.parentVC.navigator.navigate(to: .shipping)
    }
}
