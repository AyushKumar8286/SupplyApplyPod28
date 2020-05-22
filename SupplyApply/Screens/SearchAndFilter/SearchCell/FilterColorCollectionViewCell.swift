//
//  FilterColorCollectionViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 12/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

class FilterColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var imgViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewColor.clipsToBounds = true
        viewColor.layer.cornerRadius = viewColor.layer.bounds.height/2
    }

}
