//
//  CartPriceListTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 18/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class CartPriceListTableViewCell: UITableViewCell {

    var priceTotal = 0 {
        didSet {
            print(priceTotal)
        }
    }
    var cartlist : CartListModel?
    
    @IBOutlet weak var viewTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewTableView.register(UINib(nibName: "CartPriceTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartPriceTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        viewTableView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension CartPriceListTableViewCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceTotal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartPriceTableViewCell") as! CartPriceTableViewCell
        cell.lblSubTotal.text = cartlist?.totals?[indexPath.row].title
        cell.lblSubTotalPrice.text = cartlist?.totals?[indexPath.row].text
            
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
