//
//  CartPriceTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 29/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class CartPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
