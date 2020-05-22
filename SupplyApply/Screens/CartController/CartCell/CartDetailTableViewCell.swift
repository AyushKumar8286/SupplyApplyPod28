//
//  CartDetailTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 29/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol CartDetailViewDelegate : class {
    
    func clickedBtnImage(cell : CartDetailTableViewCell)
    func clickedbtnPlus(cell : CartDetailTableViewCell)
    func clickedbtnMinus(cell : CartDetailTableViewCell)
    func clickedBtnRefresh(cell : CartDetailTableViewCell)
    func clickedBtnDelete(cell : CartDetailTableViewCell)
    func clickedBtnProductName(cell : CartDetailTableViewCell)
}

class CartDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var viewRecycleAndDelete: UIView!
    
    weak var delegate: CartDetailViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        viewRecycleAndDelete.clipsToBounds = true
        viewRecycleAndDelete.layer.cornerRadius = 8
    }
    
    @IBAction func clickedBtnImage(_ sender: Any) {
        self.delegate?.clickedBtnImage(cell : self)
    }
    
    @IBAction func clickedBtnMinus(_ sender: Any) {
        self.delegate?.clickedbtnMinus(cell : self)
    }
    
    @IBAction func clickedBtnPlus(_ sender: Any) {
        self.delegate?.clickedbtnPlus(cell : self)
    }
    
    @IBAction func clickedBtnRefresh(_ sender: Any) {
        self.delegate?.clickedBtnRefresh(cell : self)
    }
    
    @IBAction func clickedBtnDelete(_ sender: Any) {
        self.delegate?.clickedBtnDelete(cell : self)
    }
    
    @IBAction func clcikedBtnProductName(_ sender: Any) {
        self.delegate?.clickedBtnProductName(cell : self)
    }
}
