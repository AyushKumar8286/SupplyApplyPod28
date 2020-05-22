//
//  MyOrderViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 28/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

// var myOrderList : MyOrder?

class MyOrderViewController: CustomViewController {

    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var myOrderList : MyOrder?
    var selectedIndex : Int? = -1
    var isSelectedIndex : [Int: Bool] = [0 : false]
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewTableView: UITableView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderlist(customerId: UserDefaults.standard.getCutomerID())
    }

    
    //MARK:- PRIVATE METHODS
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        viewTableView.register(UINib(nibName: "MyOrderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MyOrderTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        viewTableView.reloadData()
    }
        
    private func getOrderlist(customerId: String) {

        if SHRestClient.isConnectedToInternet() {

            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID()
            ]
            
            SHRestClient.getOrderList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.myOrderList = response
                        self.setUpView()
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

//MARK:- UITableViewDelegate AND UITableViewDataSource
extension MyOrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderList?.orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell") as! MyOrderTableViewCell
        
        cell.lblSubTotalName.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[0].title
        cell.lblSubTotalPrice.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[0].text
        cell.lblFlatShippingName.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[1].title
        cell.lblFlatShipRate.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[1].text
        cell.lblTotalName.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[2].title
        cell.lblTotalPrice.text = myOrderList?.orders?[indexPath.row].orderInfo?.totals?[2].text
        cell.delegate = self
        cell.lblOrder.text = "Order # " + (myOrderList?.orders?[indexPath.row].orderID ?? "")
        cell.selectionStyle = .none
        cell.myOrderlist = myOrderList
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let noOfExpendableRow = myOrderList?.orders?[indexPath.row].orderInfo?.products?.count ?? 0
        let rowHeight = 60
        let expandableHeight = (rowHeight * noOfExpendableRow) + 10
        var cellHeight : CGFloat? = 68
        let isOderBarIsSelcted = myOrderList?.orders?[indexPath.row].isSelected ?? false
        if isOderBarIsSelcted {
            cellHeight = (CGFloat(285 + expandableHeight))
        } else {
            cellHeight = 68
        }
        
        return cellHeight ?? 0.0
    }
}

//MARK:- MyOrderViewDelegate
extension MyOrderViewController : MyOrderViewDelegate {
    
    func clickedBtnOrderBar(cell: MyOrderTableViewCell, sender : UIButton) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        selectedIndex = indexpath?.row
        cell.selectedIndex = selectedIndex
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            myOrderList?.orders?[indexpath?.row ?? 0].isSelected = true
        } else {
            myOrderList?.orders?[indexpath?.row ?? 0].isSelected = false
        }
        viewTableView.reloadData()
    }
}
