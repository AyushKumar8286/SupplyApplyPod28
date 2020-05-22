//
//  MenuBarCollectionViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 30/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = viewContent.layer.bounds.size.height/2
        
    }
}
