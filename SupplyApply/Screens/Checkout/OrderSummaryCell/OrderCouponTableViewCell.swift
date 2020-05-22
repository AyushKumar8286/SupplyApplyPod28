//
//  OrderCouponTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 08/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol OrderCouponViewDelegate : class {    
    func clickedBtnDelete(cell : OrderCouponTableViewCell)
}


class OrderCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var txtFieldCoupon: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewSeparator: UIView!
    
    var delegate : OrderCouponViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        txtFieldCoupon.delegate = self
    }
    
    @IBAction func clickedBtndelete(_ sender: Any) {
        self.delegate?.clickedBtnDelete(cell : self)
    }
}


extension OrderCouponTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewSeparator.backgroundColor = Colors.tint
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewSeparator.backgroundColor = Colors.hexColor(hex: "#3C3C43")
    }
}
