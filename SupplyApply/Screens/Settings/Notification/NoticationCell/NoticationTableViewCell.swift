//
//  NoticationTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 16/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class NoticationTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
