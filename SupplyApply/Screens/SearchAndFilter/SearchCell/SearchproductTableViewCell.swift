//
//  SearchproductTableViewCell.swift
//  SupplyApply
//
//  Created by Mac3 on 11/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit

protocol SearchproductViewDelegate : class {
    
    func clickedbtnByCase1(cell : SearchproductTableViewCell, sender : UIButton)
    func clickedbtnPlus1(cell : SearchproductTableViewCell)
    func clickedbtnMinus1(cell : SearchproductTableViewCell)
    func clickedbtnAddToCart1(cell : SearchproductTableViewCell)
    func clickedbtnProductImage1(cell : SearchproductTableViewCell)
    func clickedbtnProductName1(cell : SearchproductTableViewCell)
    
    func clickedbtnByCase2(cell : SearchproductTableViewCell, sender : UIButton)
    func clickedbtnPlus2(cell : SearchproductTableViewCell)
    func clickedbtnMinus2(cell : SearchproductTableViewCell)
    func clickedbtnAddToCart2(cell : SearchproductTableViewCell)
    func clickedbtnProductImage2(cell : SearchproductTableViewCell)
    func clickedbtnProductName2(cell : SearchproductTableViewCell)
}

class SearchproductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblProductName1: UILabel!
    @IBOutlet weak var lblModel1: UILabel!
    @IBOutlet weak var lblInStock1: UILabel!
    @IBOutlet weak var lblByCase1: UILabel!
    @IBOutlet weak var lbPriceByPiece1: UILabel!
    @IBOutlet weak var lblPerPiece1: UILabel!
    @IBOutlet weak var lblPriceByCase1: UILabel!
    @IBOutlet weak var lblPerCase1: UILabel!
    @IBOutlet weak var imageViewProduct1: UIImageView!
    @IBOutlet weak var viewByCaseAndCart1: UIView!
    @IBOutlet weak var lblQuantity1: UILabel!
    @IBOutlet weak var viewByCase1: UIView!
    @IBOutlet weak var imageByCase1: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var lblCDNPiece1: UILabel!
    
    @IBOutlet weak var lblProductName2: UILabel!
    @IBOutlet weak var lblModel2: UILabel!
    @IBOutlet weak var lblInStock2: UILabel!
    @IBOutlet weak var lblByCase2: UILabel!
    @IBOutlet weak var lbPriceByPiece2: UILabel!
    @IBOutlet weak var lblPerPiece2: UILabel!
    @IBOutlet weak var lblPriceByCase2: UILabel!
    @IBOutlet weak var lblPerCase2: UILabel!
    @IBOutlet weak var imageViewProduct2: UIImageView!
    @IBOutlet weak var viewByCaseAndCart2: UIView!
    @IBOutlet weak var lblQuantity2: UILabel!
    @IBOutlet weak var viewByCase2: UIView!
    @IBOutlet weak var imageByCase2: UIImageView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var lblCDNPiece2: UILabel!
    
    weak var delegate: SearchproductViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewByCaseAndCart1.clipsToBounds = true
        viewByCaseAndCart1.layer.cornerRadius = 8
        viewByCaseAndCart2.clipsToBounds = true
        viewByCaseAndCart2.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
