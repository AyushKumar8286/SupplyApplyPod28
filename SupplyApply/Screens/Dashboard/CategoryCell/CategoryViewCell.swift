//
//  CategoryViewCell.swift
//  SupplyApply
//
//  Created by Yashvir on 25/03/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
        
    var categoryItem : Category! {
        didSet {
            if let item = categoryItem {
                if #available(iOS 11.0, *) {
                    containerView.backgroundColor = Colors.hexColor(hex: item.backgroundColor ?? "#BEBAD9")
                } else {
                    // Fallback on earlier versions
                }
                categoryLabel.text = item.name
                
                let options = ImageLoadingOptions(
                  placeholder: UIImage(named: "Image Icon"),
                  transition: .fadeIn(duration: 0.3)
                )
                let url = URL(string: item.thumb ?? "")!
                Nuke.loadImage(with: url, options: options, into: categoryImageView)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
