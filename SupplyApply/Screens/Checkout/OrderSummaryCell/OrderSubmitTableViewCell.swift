//
//  OrderSubmitTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 08/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol OrderSubmitViewDelegate : class {
    func clickedBtnSubmit(cell : OrderSubmitTableViewCell)
}

class OrderSubmitTableViewCell: UITableViewCell {

    @IBOutlet weak var viewPlaceOrder: UIView!

    var delegate : OrderSubmitViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        viewPlaceOrder.clipsToBounds = true
        viewPlaceOrder.layer.cornerRadius = viewPlaceOrder.layer.bounds.height/2
    }
    
    @IBAction func clickedBtnPlaceOrder(_ sender: Any) {
        self.delegate?.clickedBtnSubmit(cell: self)
    }
}
