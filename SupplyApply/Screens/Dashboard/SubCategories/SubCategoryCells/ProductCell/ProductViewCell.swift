//
//  ProductViewCell.swift
//  SupplyApply
//
//  Created by Yashvir on 01/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

protocol ProductViewDelegate : class {
    
    func clickedbtnByCase(cell : ProductViewCell, sender : UIButton)
    func clickedbtnPlus(cell : ProductViewCell)
    func clickedbtnMinus(cell : ProductViewCell)
    func clickedAddToCart(cell : ProductViewCell)
    func clickedAddToWishlist(cell : ProductViewCell)
    func clickedProductName(cell : ProductViewCell)
}

class ProductViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var inStockLabel: UILabel!
    @IBOutlet weak var pricePerPiece: UILabel!
    @IBOutlet weak var pricePerCase: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var byCaseButton: UIView!
    @IBOutlet weak var addToCartButton: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var imageViewByCase: UIImageView!
    @IBOutlet weak var lblByCase: UILabel!
    @IBOutlet weak var lblPricePerCase: UIStackView!
    @IBOutlet weak var lblPricePerPiece: UIStackView!
    @IBOutlet weak var lblPerPiece: UILabel!
    @IBOutlet weak var lblPerCase: UILabel!
    @IBOutlet weak var btnWishlist: UIButton!
    
    var productItem : Product! {
        didSet {
            if let product = productItem {
                nameLabel.text = product.name
                serialNumberLabel.text = product.modelNo
            }
        }
    }
    
    weak var cellProductDelegate: ProductViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCart.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusQuantity(_ sender: Any) {
        self.cellProductDelegate?.clickedbtnMinus(cell : self)
    }
    
    @IBAction func plusQuantity(_ sender: Any) {
        self.cellProductDelegate?.clickedbtnPlus(cell : self)
    }
    
    @IBAction func btnClickedByCase(_ sender: UIButton) {
        self.cellProductDelegate?.clickedbtnByCase(cell : self, sender: sender)
    }
    @IBAction func btnClickedAddToCart(_ sender: Any) {
        self.cellProductDelegate?.clickedAddToCart(cell : self)
    }
    
    @IBAction func clickedBtnWishlist(_ sender: Any) {
        self.cellProductDelegate?.clickedAddToWishlist(cell : self)
    }
    @IBAction func clickedBtnProductName(_ sender: Any) {
        self.cellProductDelegate?.clickedProductName(cell : self)
    }
}
