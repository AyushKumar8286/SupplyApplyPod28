//
//  CartCheckoutTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 29/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol CartCheckoutViewDelegate : class {
    func clickedCheckoutBtn()
}

class CartCheckoutTableViewCell: UITableViewCell {

    var delegate : CartCheckoutViewDelegate?
    
    @IBOutlet weak var viewCart: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        viewCart.clipsToBounds = true
        viewCart.layer.cornerRadius = viewCart.layer.bounds.height/2
    }
    
    @IBAction func clickedBtnCheckout(_ sender: Any) {
        delegate?.clickedCheckoutBtn()
    }
}
