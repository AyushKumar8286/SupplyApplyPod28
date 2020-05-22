//
//  SettingsTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 23/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol SettingCellViewDelegate : class {
    
    func clickedDarkMode(cell : SettingsTableViewCell)
}

class SettingsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageRightArrow: UIImageView!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var constraintViewTop: NSLayoutConstraint!
    
    weak var delegate: SettingCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickedBtnToggle(_ sender: Any) {
        self.delegate?.clickedDarkMode(cell : self)
    }
}
