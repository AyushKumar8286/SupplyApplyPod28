//
//  MyOrderTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 28/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol MyOrderViewDelegate : class {
    
    func clickedBtnOrderBar(cell : MyOrderTableViewCell, sender : UIButton)
}

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var imageViewArrow: UIImageView!
    @IBOutlet weak var expandTableView: UITableView!
    @IBOutlet weak var viewExpandable: UIView!
    @IBOutlet weak var lblSubTotalName: UILabel!
    @IBOutlet weak var lblSubTotalPrice: UILabel!
    @IBOutlet weak var lblFlatShippingName: UILabel!
    @IBOutlet weak var lblFlatShipRate: UILabel!
    @IBOutlet weak var lblTotalName: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var myOrderlist : MyOrder?
    var selectedIndex : Int? = 0
    weak var delegate: MyOrderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        expandTableView.register(UINib(nibName: "ExpandTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ExpandTableViewCell")
        expandTableView.delegate = self
        expandTableView.dataSource = self
        expandTableView.reloadData()
    }
    
        
    @IBAction func clickedBtnOrderBar(_ sender: UIButton) {
        
        self.delegate?.clickedBtnOrderBar(cell: self, sender: sender)
    }
}

extension MyOrderTableViewCell : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderlist?.orders?[selectedIndex ?? 0].orderInfo?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandTableViewCell") as! ExpandTableViewCell
        cell.lblProductName.text = myOrderlist?.orders?[selectedIndex ?? 0].orderInfo?.products?[indexPath.row].name
        cell.lblProductNumber.text = myOrderlist?.orders?[selectedIndex ?? 0].orderInfo?.products?[indexPath.row].quantity
        cell.lblProductPrice.text = myOrderlist?.orders?[selectedIndex ?? 0].orderInfo?.products?[indexPath.row].price
        
        return cell
        
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
