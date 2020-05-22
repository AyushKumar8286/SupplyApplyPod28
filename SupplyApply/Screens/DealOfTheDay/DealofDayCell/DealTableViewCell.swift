//
//  DealTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 30/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol DealTableViewDelegate : class {
    
    func clickedbtnByCase1(cell : DealTableViewCell, sender : UIButton)
    func clickedbtnPlus1(cell : DealTableViewCell)
    func clickedbtnMinus1(cell : DealTableViewCell)
    func clickedbtnAddToCart1(cell : DealTableViewCell)
    func clickedbtnProductImage1(cell : DealTableViewCell)
    func clickedbtnProductName1(cell : DealTableViewCell)
    
    func clickedbtnByCase2(cell : DealTableViewCell, sender : UIButton)
    func clickedbtnPlus2(cell : DealTableViewCell)
    func clickedbtnMinus2(cell : DealTableViewCell)
    func clickedbtnAddToCart2(cell : DealTableViewCell)
    func clickedbtnProductImage2(cell : DealTableViewCell)
    func clickedbtnProductName2(cell : DealTableViewCell)
}

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var lblProductName1: UILabel!
    @IBOutlet weak var lblProductPrice1: UILabel!
    @IBOutlet weak var lblDealPrice1: UILabel!
    @IBOutlet weak var lblInStock1: UILabel!
    @IBOutlet weak var lblOfferEndsIn1: UILabel!
    @IBOutlet weak var imageViewProduct1: UIImageView!
    @IBOutlet weak var viewByCaseAndCart1: UIView!
    @IBOutlet weak var lblQuantity1: UILabel!
    @IBOutlet weak var viewByCase1: UIView!
    @IBOutlet weak var lblByCase1: UILabel!
    @IBOutlet weak var imageByCase1: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    
    
    @IBOutlet weak var lblProductName2: UILabel!
    @IBOutlet weak var lblProductPrice2: UILabel!
    @IBOutlet weak var lblDealPrice2: UILabel!
    @IBOutlet weak var lblInStock2: UILabel!
    @IBOutlet weak var lblOfferEndsIn2: UILabel!
    @IBOutlet weak var imageViewProduct2: UIImageView!
    @IBOutlet weak var viewByCaseAndCart2: UIView!
    @IBOutlet weak var lblQuantity2: UILabel!
    @IBOutlet weak var viewByCase2: UIView!
    @IBOutlet weak var lblByCase2: UILabel!
    @IBOutlet weak var imageByCase2: UIImageView!
    @IBOutlet weak var viewRight: UIView!
    
    weak var delegate: DealTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewByCaseAndCart1.clipsToBounds = true
        viewByCaseAndCart1.layer.cornerRadius = 8
        viewByCaseAndCart2.clipsToBounds = true
        viewByCaseAndCart2.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func clickedBtnProductImage1(_ sender: UIButton) {
        self.delegate?.clickedbtnProductImage1(cell: self)
    }
    
    @IBAction func clickedBtnByCase1(_ sender: UIButton) {
        self.delegate?.clickedbtnByCase1(cell: self,sender : sender)
    }
    
    @IBAction func clickedBtnAddToCart1(_ sender: Any) {
        self.delegate?.clickedbtnAddToCart1(cell: self)
    }
    
    @IBAction func clickedBtnPlus1(_ sender: Any) {
        self.delegate?.clickedbtnPlus1(cell: self)
    }
    
    @IBAction func clickedBtnMinus1(_ sender: Any) {
        self.delegate?.clickedbtnMinus1(cell: self)
    }
    
    @IBAction func clcikedBtnProductName1(_ sender: Any) {
        self.delegate?.clickedbtnProductName1(cell: self)
    }
    
    @IBAction func clickedBtnProductImage2(_ sender: Any) {
        self.delegate?.clickedbtnProductImage2(cell: self)
    }
    
    @IBAction func clickedBtnByCase2(_ sender: UIButton) {
        self.delegate?.clickedbtnByCase2(cell: self, sender : sender)
    }
    
    @IBAction func clickedBtnAddToCart2(_ sender: Any) {
        self.delegate?.clickedbtnAddToCart2(cell: self)
    }
    
    @IBAction func clickedBtnPlus2(_ sender: Any) {
        self.delegate?.clickedbtnPlus2(cell: self)
    }
    
    @IBAction func clickedBtnMinus2(_ sender: Any) {
        self.delegate?.clickedbtnMinus2(cell: self)
    }
    
    @IBAction func clickedBtnProductName2(_ sender: Any) {
        self.delegate?.clickedbtnProductName2(cell: self)
    }
}
