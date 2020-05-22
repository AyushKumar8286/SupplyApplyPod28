//
//  ProductListController.swift
//  SupplyApply
//
//  Created by Mac3 on 24/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class ProductListController: CustomViewController  {
    
    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var productData : DataClass?
    var bestSeller : [BestSeller] = []
    var similarProducts : [SimilarProducts] = []
    var recentlyViewed : [RecentViewed] = []
    var imageData : [Image] = []
    var productOptionValue : [ProductOptionValue] = []
    var options : Options?
    var productidarray : [String] = []
    var productName : String?
    var productId : String?    
    var productquantity = 1
    var productOption : String?
    var isByPiece = false
    var cartResponse : GenericResponse?
    var wishlistProducts : [Product] = []
    
    
    //MARK:- IBOUTLET
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var lblInStock: UILabel!
    @IBOutlet weak var lblInPiece: UIStackView!
    @IBOutlet weak var lblInCase: UIStackView!
    @IBOutlet weak var lblPiecePrice: UILabel!
    @IBOutlet weak var lblCasePrice: UILabel!
    @IBOutlet weak var lblPerCase: UILabel!
    @IBOutlet weak var lblProdtNameBottom: UILabel!
    @IBOutlet weak var viewByCase: UIView!
    @IBOutlet weak var lblSimilarProduct: UILabel!
    @IBOutlet weak var viewSimilarProduct: UIView!
    @IBOutlet weak var viewAddToCart: UIView!
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblByCase: UILabel!
    @IBOutlet weak var imageByCase: UIImageView!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var viewCollectionView: UICollectionView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productId = UserDefaults.standard.getProductID()
        self.getProductInfo(productid: productId ?? "")
        
    }
    
    //MARK:- PRIVATE METHODS
    
    private func getProductInfo(productid: String) {

        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            var productId = ""            
            if productid == "" {
                productId = UserDefaults.standard.getProductID()
            } else {
                productId = productid
            }
            
            let params : [String: Any] = [
                "product_id" : productId
            ]
            
            SHRestClient.getProductDetail(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.productData = response.data
                        self.bestSeller = response.data?.bestSeller ?? []
                        self.similarProducts = response.data?.similarProducts ?? []
                        self.recentlyViewed = response.data?.recentViewed ?? []
                        self.imageData = response.data?.images ?? []
                        self.options = response.data?.options
                        self.setUpView()
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    private func setUpView() {
        
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
//        parentVC.topBar.backgroundColor = Colors.hexColor(hex: category.backgroundColor ?? "#BEBAD9")
        viewCollectionView.delegate = self
        viewCollectionView.dataSource = self
        viewCollectionView?.register(UINib(nibName: "ProductCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        viewCollectionView.showsHorizontalScrollIndicator = false
        viewCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        
        lblProductName.text = productData?.name
        lblSerialNumber.text = productData?.model
        lblInStock.text = productData?.stock
        lblProdtNameBottom.text = productData?.name
        viewAddToCart.clipsToBounds = true
        viewAddToCart.layer.cornerRadius = viewAddToCart.layer.bounds.height/2
        let option = ImageLoadingOptions(
            placeholder: UIImage(named: "Image Icon"),
            transition: .fadeIn(duration: 0.0)
        )
        let url = URL(string: imageData.first?.thumb ?? "")!
        Nuke.loadImage(with: url, options: option, into: imageViewProduct)
        
        if similarProducts.count == 0 {
            viewSimilarProduct.isHidden = true
            lblSimilarProduct.isHidden = true
        } else {
            viewSimilarProduct.isHidden = false
            lblSimilarProduct.isHidden = false
        }
        
        if productData?.optionsAvailable ?? false {
            
            viewByCase.isHidden = false
            lblInCase.isHidden = false
            lblInPiece.isHidden = false
            lblPiecePrice.text = options?.productOptionValue?[0].price
            lblCasePrice.text = options?.productOptionValue?[1].price
            lblPerCase.isHidden = false
            
        } else {
            
            viewByCase.isHidden = true
            lblInCase.isHidden = false
            lblInPiece.isHidden = true
            lblPerCase.isHidden = true
            lblCasePrice.isHidden = false
            lblCasePrice.text = productData?.price
        }
    }
    
    private func addToCart(productid:String, quantity:String, option : String, productOption : String) {

        if SHRestClient.isConnectedToInternet() {

            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "product_id" : productid ,
                "quantity" : quantity,
                "option[\(productOption)]" : option
            ]
            
            SHRestClient.addToCart(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.cartResponse = response
                        let msg = self.cartResponse?.message
//                        self.parentVC.showToast(message: msg ?? "", type: .info)
                        self.view.makeToast(msg)
                        self.parentVC.getCartCount(customerId : UserDefaults.standard.getCutomerID())
                        
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    private func addToWishList(productid:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "product_id" : productid
            ]
            
            SHRestClient.wishlistAdd(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.cartResponse = response
                        self.btnWishlist.setImage(UIImage(named: "addToWishlist.pdf"), for: UIControl.State.normal)
//                        self.products[index].isWishList = true
                        let msg = self.cartResponse?.message
//                        self.parentVC.showToast(message: msg ?? "", type: .info)
                        self.view.makeToast(msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
        
    }
    
        
    //MARK:- IBACTION METHODS
    @IBAction func clickedBtnWishlist(_ sender: Any) {
        
        self.addToWishList(productid: productData?.productID ?? "")
    }
    
    @IBAction func clickedBtnProductImage(_ sender: Any) {
        parentVC.navigator.navigate(to: .productImage(productName: productData?.name ?? "", productModel: productData?.model ?? "", productImage: productData?.images?.first?.thumb ?? ""))
    }
    
    @IBAction func clickedBtnMinus(_ sender: Any) {
        if ((Int(lblQuantity.text ?? "") ?? 0) == 1) {
            return
        } else {
            lblQuantity.text = String((Int(lblQuantity.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(lblQuantity.text ?? "") ?? 0)
    }
    
    @IBAction func clickedBtnPlus(_ sender: Any) {
        lblQuantity.text = String((Int(lblQuantity.text ?? "") ?? 0) + 1)
        productquantity = (Int(lblQuantity.text ?? "") ?? 0)
    }
    
    @IBAction func clickedBtnByCase(_ sender: UIButton) {
        
        sender.isSelected = !(sender.isSelected)
        if !(sender.isSelected) {
            
            lblByCase.text = "By Case"
            isByPiece = false
            imageByCase.image = UIImage(named: "byCase.pdf")
        } else {
            
            lblByCase.text = "By Piece"
            isByPiece = true
            imageByCase.image = UIImage(named: "byPiece.pdf")
        }
    }
    
    @IBAction func clickedBtnAddToCart(_ sender: Any) {
        
        if productData?.optionsAvailable ?? false {
            
            if isByPiece {
                let prodOption = options?.productOptionValue?[0].productOptionValueID ?? ""
                self.addToCart(productid: productData?.productID ?? "", quantity: String(productquantity), option : prodOption , productOption : options?.productOptionID ?? "")
            } else {
                let prodOption = options?.productOptionValue?[1].productOptionValueID ?? ""
                self.addToCart(productid: productData?.productID ?? "", quantity: String(productquantity), option : prodOption , productOption : options?.productOptionID ?? "")
            }
            
        } else {
            self.addToCart(productid: productData?.productID ?? "", quantity: String(productquantity), option : "" , productOption : "")
        }
    }
}

  //MARK:- COLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS

extension ProductListController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.similarProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        
        if similarProducts.count > 0 {
            cell.lblProduct.text = similarProducts[indexPath.row].name
            let option = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            let url = URL(string: similarProducts[indexPath.row].thumb ?? "")!
            Nuke.loadImage(with: url, options: option, into: cell.imageViewProduct)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.bounds.width/4, height: collectionView.layer.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UserDefaults.standard.setProductID(value: similarProducts[indexPath.row].productID ?? "")
        UserDefaults.standard.setProductName(value: similarProducts[indexPath.row].name ?? "")
        parentVC.navigator.navigate(to: .productInfo(productName: similarProducts[indexPath.row].name ?? "", productId: similarProducts[indexPath.row].productID ?? ""))
        
    }
}

