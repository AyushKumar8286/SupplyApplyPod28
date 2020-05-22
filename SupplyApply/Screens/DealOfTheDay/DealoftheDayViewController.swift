//
//  DealoftheDayViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 30/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke

class DealoftheDayViewController: CustomViewController {

     //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var dealList : DealList?
    var menuString = [String]()
    var categoryId = [String]()
    var categories : [Category] = [] {
        didSet {
            menuString.append("ALL")
            categoryId.append("")
            for i in 0..<(categories.count){
                menuString.append(categories[i].name ?? "")
                categoryId.append(categories[i].categoryID ?? "")
            }
        }
    }
    var cartResponse : GenericResponse?
    var SelectedIndex = 0
    var productquantity = 1
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewCollectionView: UICollectionView!
    @IBOutlet weak var viewTableView: UITableView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getDealList(categoryId: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.parentVC.btnDealOfTheDay.setImage(UIImage(named: "icon-quick-shop.pdf"), for: .normal)
    }
    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        self.parentVC.btnDealOfTheDay.setImage(UIImage(named: "icon-quick-shop cross.pdf"), for: .normal)
        getCategories()
        viewCollectionView.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        viewCollectionView.clipsToBounds = false
        viewCollectionView.layer.masksToBounds = false
        
        viewCollectionView.register(UINib(nibName: "MenuBarCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MenuBarCollectionViewCell")
        viewCollectionView.delegate = self
        viewCollectionView.dataSource = self
        viewTableView.register(UINib(nibName: "DealTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DealTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
    }
        
        
    func getCategories() {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getCategories { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if let categories = response.category {
                        self.categories = categories
                        self.viewCollectionView.reloadData()
                    } else {
//                        self.parentVC.showToast(message : "Failed to fetch categories", type: .failure)
                        self.view.makeToast("Failed to fetch categories")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            }
        } else {
            self.showNoInternetWarning()
        }
    }
    
    func getDealList(categoryId : String) {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getDealList(categoryId: categoryId) { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    
                    self.dealList = response
                    self.viewTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
//                    self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            }
        } else {
            self.showNoInternetWarning()
        }
    }
    
    func addToCart(productid:String, quantity:String, option : String, productOption : String) {

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
                        self.parentVC.getCartCount(customerId : UserDefaults.standard.getCutomerID())
                        self.view.makeToast(msg)

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
}

//MARK:- COLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS

extension DealoftheDayViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SelectedIndex = indexPath.row
        self.getDealList(categoryId: categoryId[indexPath.row])
        viewCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCollectionViewCell", for: indexPath) as! MenuBarCollectionViewCell
       
        if menuString.count > 0 {
            cell.lblCategoryName.text = menuString[indexPath.row]
        }

        if SelectedIndex == indexPath.row {
            cell.viewContent.backgroundColor = Colors.hexColor(hex: "#F2A7BB")
            cell.lblCategoryName.textColor = .white
        } else {
            cell.viewContent.backgroundColor = .white
            cell.lblCategoryName.textColor = Colors.label
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if menuString.count > 0 {
            let text = menuString[indexPath.row]
            let font = UIFont.systemFont(ofSize: 16)
            let width = UILabel.textWidth(font: font, text: text)
            return CGSize(width: width + 40 + 40, height: viewCollectionView.layer.bounds.height)
        } else {
            return CGSize(width: viewCollectionView.layer.bounds.width/3 , height: viewCollectionView.layer.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE

extension DealoftheDayViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ((dealList?.products?.count ?? 0)%2) == 0 {
            return ((dealList?.products?.count ?? 0)/2)
        } else {
            return (((dealList?.products?.count ?? 0) - 1)/2) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealTableViewCell") as! DealTableViewCell

        cell.delegate = self
        cell.lblProductName1.text = dealList?.products?[indexPath.row * 2].name
        cell.lblProductPrice1.text = dealList?.products?[indexPath.row * 2].price
        cell.lblInStock1.text = dealList?.products?[indexPath.row * 2].stockStatus
        cell.lblOfferEndsIn1.isHidden = true
        cell.lblDealPrice1.text = dealList?.products?[indexPath.row * 2].special
        let option1 = ImageLoadingOptions(
            placeholder: UIImage(named: "Image Icon"),
            transition: .fadeIn(duration: 0.0)
        )
        let url1 = URL(string: dealList?.products?[indexPath.row * 2].thumb ?? "")!
        Nuke.loadImage(with: url1, options: option1, into: cell.imageViewProduct1)
        if dealList?.products?[indexPath.row * 2].optionsAvailable ?? false {
            cell.viewByCase1.isHidden = false
        } else {
            cell.viewByCase1.isHidden = true
        }
        
        if ((((dealList?.products?.count ?? 0)%2) != 0) && (indexPath.row*2 + 1 == dealList?.products?.count)) {
            
            cell.viewRight.isHidden = true

        } else {
            cell.viewRight.isHidden = false
            cell.lblProductName2.text = dealList?.products?[(indexPath.row * 2) + 1].name
            cell.lblProductPrice2.text = dealList?.products?[(indexPath.row * 2) + 1].price
            cell.lblInStock2.text = dealList?.products?[(indexPath.row * 2) + 1].stockStatus
            cell.lblOfferEndsIn2.isHidden = true
            cell.lblDealPrice2.text = dealList?.products?[(indexPath.row * 2) + 1].special
            let option2 = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            let url2 = URL(string: dealList?.products?[(indexPath.row * 2) + 1].thumb ?? "")!
            Nuke.loadImage(with: url2, options: option2, into: cell.imageViewProduct2)
            if dealList?.products?[(indexPath.row * 2) + 1].optionsAvailable ?? false {
                cell.viewByCase2.isHidden = false
            } else {
                cell.viewByCase2.isHidden = true
            }
        }
        
        
        
//        if ((dealList?.products?.count ?? 0)%2) == 0 {
//
//            cell.viewRight.isHidden = false
//            cell.lblProductName2.text = dealList?.products?[(indexPath.row * 2) + 1].name
//            cell.lblProductPrice2.text = dealList?.products?[(indexPath.row * 2) + 1].price
//            cell.lblInStock2.text = dealList?.products?[(indexPath.row * 2) + 1].stockStatus
//            cell.lblOfferEndsIn2.isHidden = true
//            cell.lblDealPrice2.text = dealList?.products?[(indexPath.row * 2) + 1].special
//            let option2 = ImageLoadingOptions(
//                placeholder: UIImage(named: "Image Icon"),
//                transition: .fadeIn(duration: 0.0)
//            )
//            let url2 = URL(string: dealList?.products?[(indexPath.row * 2) + 1].thumb ?? "")!
//            Nuke.loadImage(with: url2, options: option2, into: cell.imageViewProduct2)
//            if dealList?.products?[(indexPath.row * 2) + 1].optionsAvailable ?? false {
//                cell.viewByCase2.isHidden = false
//            } else {
//                cell.viewByCase2.isHidden = true
//            }
//        } else {
//            cell.viewRight.isHidden = true
//        }
        
        return cell        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- DealTableViewDelegate
extension DealoftheDayViewController : DealTableViewDelegate {
    
    func clickedbtnByCase1(cell: DealTableViewCell, sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        if !(sender.isSelected) {
            
            cell.lblByCase1.text = "By Case"
            cell.imageByCase1.image = UIImage(named: "byCase.pdf")
        } else {
            
            cell.lblByCase1.text = "By Piece"
            cell.imageByCase1.image = UIImage(named: "byPiece.pdf")
        }
    }
    
    func clickedbtnPlus1(cell: DealTableViewCell) {
        
        cell.lblQuantity1.text = String((Int(cell.lblQuantity1.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.lblQuantity1.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus1(cell: DealTableViewCell) {
        
        if ((Int(cell.lblQuantity1.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.lblQuantity1.text = String((Int(cell.lblQuantity1.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(cell.lblQuantity1.text ?? "") ?? 0)
    }
    
    func clickedbtnAddToCart1(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = dealList?.products?[(indexpath?.row ?? 0) * 2].productID ?? ""
        var option : String?
        let productoption = dealList?.products?[(indexpath?.row ?? 0) * 2].options?.first?.productOptionID
        if dealList?.products?[(indexpath?.row ?? 0) * 2].optionsAvailable ?? false {
            
            if !(dealList?.products?[(indexpath?.row ?? 0) * 2].isButtonCaseClicked ?? false) {
                option = dealList?.products?[(indexpath?.row ?? 0) * 2].options?.first?.productOptionValue?[0].productOptionValueID
            } else {
                option = dealList?.products?[(indexpath?.row ?? 0) * 2].options?.first?.productOptionValue?[1].productOptionValueID
            }
        } else {
            option = nil
        }
        self.addToCart(productid: productid, quantity: String(productquantity), option: option ?? "", productOption: productoption ?? "")
    }
    
    func clickedbtnProductImage1(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productname = dealList?.products?[(indexpath?.row ?? 0)*2].name ?? ""
        let productModel = dealList?.products?[(indexpath?.row ?? 0)*2].modelNo ?? ""
        let productThumb = dealList?.products?[(indexpath?.row ?? 0)*2].thumb ?? ""
        self.parentVC.navigator.navigate(to: .productImage(productName: productname, productModel: productModel, productImage: productThumb))
    }
    
    func clickedbtnProductName1(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = dealList?.products?[(indexpath?.row ?? 0)*2].productID ?? ""
        let productname = dealList?.products?[(indexpath?.row ?? 0)*2].name ?? ""
        UserDefaults.standard.setProductID(value: productid)
        UserDefaults.standard.setProductName(value: productname)
        self.parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
    
    func clickedbtnByCase2(cell: DealTableViewCell, sender : UIButton) {
        
        sender.isSelected = !sender.isSelected
        if !(sender.isSelected) {
            
            cell.lblByCase2.text = "By Case"
            cell.imageByCase2.image = UIImage(named: "byCase.pdf")
        } else {
            
            cell.lblByCase2.text = "By Piece"
            cell.imageByCase2.image = UIImage(named: "byPiece.pdf")
        }
    }
    
    func clickedbtnPlus2(cell: DealTableViewCell) {
        
        cell.lblQuantity2.text = String((Int(cell.lblQuantity2.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.lblQuantity2.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus2(cell: DealTableViewCell) {
        
        if ((Int(cell.lblQuantity2.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.lblQuantity2.text = String((Int(cell.lblQuantity2.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(cell.lblQuantity2.text ?? "") ?? 0)
    }
    
    func clickedbtnAddToCart2(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].productID ?? ""
        var option : String?
        let productoption = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionID
        if dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].optionsAvailable ?? false {
            
            if !(dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].isButtonCaseClicked ?? false) {
                option = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionValue?[0].productOptionValueID
            } else {
                option = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionValue?[1].productOptionValueID
            }
        } else {
            option = nil
        }
        self.addToCart(productid: productid, quantity: String(productquantity), option: option ?? "", productOption: productoption ?? "")
    }
    
    func clickedbtnProductImage2(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productname = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].name ?? ""
        let productModel = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].modelNo ?? ""
        let productThumb = dealList?.products?[((indexpath?.row ?? 0) * 2) + 1].thumb ?? ""
        self.parentVC.navigator.navigate(to: .productImage(productName: productname, productModel: productModel, productImage: productThumb))
    }
    
    func clickedbtnProductName2(cell: DealTableViewCell) {
        
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = dealList?.products?[((indexpath?.row ?? 0)*2) + 1].productID ?? ""
        let productname = dealList?.products?[((indexpath?.row ?? 0)*2) + 1].name ?? ""
        UserDefaults.standard.setProductID(value: productid)
        UserDefaults.standard.setProductName(value: productname)
        self.parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
}
