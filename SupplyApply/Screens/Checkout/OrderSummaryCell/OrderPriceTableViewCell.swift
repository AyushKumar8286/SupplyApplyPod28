//
//  OrderPriceTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 08/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class OrderPriceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblSubTotalPrice: UILabel!
    @IBOutlet weak var lblFlatShipping: UILabel!
    @IBOutlet weak var lblFlatShippingRate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalPriceRate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
