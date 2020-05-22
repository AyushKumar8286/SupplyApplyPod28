//
//  ShippingMethodTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 07/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol ShippingMethodViewDelegate : class {

    func clickedBtnShipMethod1(cell : ShippingMethodTableViewCell, sender : UIButton)
    func clickedBtnShipMethod2(cell : ShippingMethodTableViewCell, sender : UIButton)
}

class ShippingMethodTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblFlateRate1: UILabel!
    @IBOutlet weak var lblFlatCost1: UILabel!
    @IBOutlet weak var imageViewSelect1: UIImageView!
    @IBOutlet weak var lblFlateRate2: UILabel!
    @IBOutlet weak var lblFlatCost2: UILabel!
    @IBOutlet weak var imageViewSelect2: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var imageViewTop: UIImageView!
    
    var delegate : ShippingMethodViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnShipMethod1(_ sender: UIButton) {
        self.delegate?.clickedBtnShipMethod1(cell: self, sender: sender)
    }
    
    @IBAction func clickedBtnShipMethod2(_ sender: UIButton) {
        self.delegate?.clickedBtnShipMethod2(cell: self, sender: sender)
    }
}
