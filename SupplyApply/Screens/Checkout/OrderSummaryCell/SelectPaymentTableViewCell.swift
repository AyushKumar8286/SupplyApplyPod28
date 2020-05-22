//
//  SelectPaymentTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 18/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol SelectPaymentViewDelegate : class {
    func clickedBtnSelectPayment(cell : SelectPaymentTableViewCell)
}

class SelectPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var btnPayfrom: UIButton!
        
    var delegate : SelectPaymentViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    @IBAction func clickedBtnPayFrom(_ sender: Any) {
        self.delegate?.clickedBtnSelectPayment(cell: self)
    }    
}
