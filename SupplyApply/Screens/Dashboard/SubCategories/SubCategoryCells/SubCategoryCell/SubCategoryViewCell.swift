//
//  SubCategoryViewCell.swift
//  SupplyApply
//
//  Created by Yashvir on 01/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class SubCategoryViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var categoryItem : Category! {
        didSet {
            if let category = categoryItem {
                titleLabel.text = category.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
