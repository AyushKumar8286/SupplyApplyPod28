//
//  SubCategoryController.swift
//  SupplyApply
//
//  Created by Yashvir on 01/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke
import DropDown

class SubCategoryController: CustomViewController {

    var parentVC : AnimatedAppTabBar!
    var category : Category!
    var productquantity = 1
    var isProductsScreen = false
    weak var producatViewCell : ProductViewCell?
    var subCategories : [Category] = []
    var products : [Product] = []
    var cartResponse : GenericResponse?
    var wishlistProducts : [Product] = []
    var iscallFrom : String?
    var sortList : SortList?
    var selectedIndex = -1
    var filterList : FilterData?
    let brandDropDown = DropDown()
    var colorOption = [String]()
    var isFromCategory = true
    var isFromSort = false
    var isFromFilter = false
    var page = 1
    var sortby = ""
    var order = ""
    var subCategoriesData : SubCategories! {
        didSet {
            if let data = subCategoriesData {
                if data.category?.count ?? 0 > 0 {
                    self.isProductsScreen = false
                    self.subCategories = data.category!
                    viewSortFilter.isHidden = true
                    ConstaintViewHeight.constant = 0.0
                } else if data.products?.count ?? 0 > 0 {
                    self.isProductsScreen = true
                    self.products = data.products!
                    viewSortFilter.isHidden = false
                    ConstaintViewHeight.constant = 58.0
                }
            }
        }
    }
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var viewSortFilter: UIView!
    @IBOutlet weak var ConstaintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var viewTableViwSort: UITableView!
    @IBOutlet weak var constraintViewSortHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var lblMinPrice: UILabel!
    @IBOutlet weak var lblMaxPrice: UILabel!
//    @IBOutlet weak var viewRangeSlider: RangeSlider!
    @IBOutlet weak var viewBrandDropDown: UIView!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var viewApplyFilter: UIView!
    @IBOutlet weak var lblMinCurrency: UILabel!
    @IBOutlet weak var lblMaxCurrency: UILabel!
    @IBOutlet weak var viewSortBackground: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        viewSortFilter.isHidden = true
        viewSort.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        if iscallFrom == "Settings" {
            isProductsScreen = true
            viewSortFilter.isHidden = true
            ConstaintViewHeight.constant = 0.0
        } else {
            self.getSubCategories(page: "1")
        }
    }

    func setupView() {
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        parentVC.topBar.backgroundColor = Colors.hexColor(hex: category.backgroundColor ?? "#BEBAD9")
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.register(UINib(nibName: "SubCategoryViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SubCategoryViewCell")
        tableView1.register(UINib(nibName: "ProductViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductViewCell")
        tableView1.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        viewTableViwSort.register(UINib(nibName: "SortTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SortTableViewCell")
        viewTableViwSort.delegate = self
        viewTableViwSort.dataSource = self
        
        colorCollectionView.register(UINib(nibName: "FilterColorCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FilterColorCollectionViewCell")
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        if iscallFrom == "Settings" {
            getAllWishList()
            isProductsScreen = true
            viewSortFilter.isHidden = true
            ConstaintViewHeight.constant = 0.0
        }
        
        viewFilter.isHidden = true
//        viewRangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
        viewApplyFilter.clipsToBounds = true
        viewApplyFilter.layer.cornerRadius = viewApplyFilter.layer.bounds.height/2
        viewSortBackground.isHidden = true
        viewSortBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func getSubCategories(page : String) {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getSubCategories(categoryId: self.category.categoryID ?? "", page: page, option: "") { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        if page == "1" {
                            self.subCategoriesData = response
                            self.subCategories = []
                        }
                        self.subCategories = response.category ?? []
                        self.tableView1.reloadData()
                    } else {
                        self.parentVC.viewError.isHidden = false
                        self.parentVC.lblError.text = response.message
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
    
    func getSortList() {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getSortList() { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.sortList = response
                        let height : CGFloat = CGFloat((50 * (self.sortList?.sorts?.count ?? 0)))
                        self.constraintViewSortHeight.constant = height + 45
                        self.viewTableViwSort.reloadData()
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
    
    func getSortProduct(search : String,sortBy : String, order: String, page:String) {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getSort(search: search, sortby: sortBy, order: order, categoryId: self.category.categoryID ?? "", page: page) { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        if page == "1" {
                            self.subCategoriesData = response
                            self.subCategories = []
                        }
                        self.subCategories = response.category ?? []
                        self.viewSort.isHidden = true
                        self.tableView1.isUserInteractionEnabled = true
                        self.viewSortFilter.isUserInteractionEnabled = true
                        self.viewSortFilter.isHidden = false
                        self.parentVC.bottomBar.isHidden = false
                        self.parentVC.constraintBottomBarHeight.constant = 70
                        self.viewSortBackground.isHidden = true
                        self.parentVC.viewSortBackground.isHidden = true
                        self.tableView1.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    //                        self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            }
        } else {
            self.showNoInternetWarning()
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
    
    private func getAllWishList() {

        if SHRestClient.isConnectedToInternet() {

            self.showLoading(isLoading: true)
            let custId = UserDefaults.standard.getCutomerID()
            let params : [String: Any] = [
                "customer_id" : custId
            ]

            SHRestClient.getAllWishlist(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.products = response.products ?? []
                        self.tableView1.reloadData()
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
    
    private func addToWishList(productid:String, index: Int) {

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
                        self.products[index].isWishList = true
                        let msg = self.cartResponse?.message
//                        self.getAllWishList()
//                        self.parentVC.showToast(message: msg ?? "", type: .info)
                        self.view.makeToast(msg)
                        debugPrint(response)
                        self.tableView1.reloadData()
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
    
    private func removeWishList(productid:String, customerId: String) {

            if SHRestClient.isConnectedToInternet() {

                self.showLoading(isLoading: true)
                
                let params : [String: Any] = [
                    "product_id" : productid,
                    "customer_id" : customerId
                ]
                
                SHRestClient.wishlistRemove(params: params , completion: { (result) in
                    self.showLoading(isLoading: false)
                    switch result {
                    case .success(let response):
                        if response.success ?? false {
                            
                            self.cartResponse = response
                            let msg = self.cartResponse?.message
    //                        self.parentVC.showToast(message: msg ?? "", type: .info)
                            self.view.makeToast(msg)
                            debugPrint(response)
                            self.getAllWishList()
                            self.tableView1.reloadData()
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
    
    func tapOnProductName(productName : String, productid : String) {
        
        UserDefaults.standard.setProductID(value: productid)
        UserDefaults.standard.setProductName(value: productName)
        parentVC.navigator.navigate(to: .productInfo(productName: productName, productId: productid))
    }
    
    func getFilterList() {
        if SHRestClient.isConnectedToInternet() {
            
            let params : [String: Any] = [
                "filter_type" : "search",
                "category_id" : self.category.categoryID ?? ""
            ]
            
            self.showLoading(isLoading: true)
            SHRestClient.getfilter(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        self.filterList = response
                        self.loadFilterView()
                        for _ in 0..<(self.filterList?.filterData?[0].color?.count ?? 0) {
                            self.colorOption.append("")
                        }
                        self.colorCollectionView.reloadData()
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
    
    func applyFilter(search: String, option : [String], brand : String, minprice : String, maxprice : String, filterCategoryid : [String], page : String, categoryId : String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.applyFilter(search: search, option: option, brand: brand, minprice: minprice, maxprice: maxprice, filterCategoryid: filterCategoryid, page: "1", categoryId: categoryId, completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        if page == "1" {
                            self.subCategoriesData = response
                            self.subCategories = []
                        }
                        
//                        self.subCategoriesData = response
                        self.subCategories = response.category ?? []
                        self.viewFilter.isHidden = true
                        self.tableView1.isHidden = false
                        self.viewSortFilter.isHidden = false
                        self.viewSort.isHidden = true
                        self.tableView1.reloadData()
                    } else {
                        self.parentVC.viewError.isHidden = false
                        self.parentVC.lblError.text = response.message
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
    
    func loadFilterView() {
        
        let currency = filterList?.filterData?[2].price?.currencyTitle
        lblMinCurrency.text = currency
        lblMaxCurrency.text = currency
        loadRangeSliderView()
        lblMaxPrice.text = (filterList?.filterData?[2].price?.maxprice ?? "0")
        lblMinPrice.text = (filterList?.filterData?[2].price?.minprice ?? "0")
        
        // The view to which the drop down will appear on
        brandDropDown.anchorView = viewBrandDropDown
        brandDropDown.direction = .any
        brandDropDown.dismissMode = .automatic
        DropDown.appearance().textColor = UIColor.red.withAlphaComponent(0.5)
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        self.setupBrandDropDown()
    }
    
    func loadRangeSliderView() {
        
        let max =  roundValue(value: (Double(filterList?.filterData?[2].price?.maxprice ?? "0") ?? 0))
        let min =  roundValue(value: (Double(filterList?.filterData?[2].price?.minprice ?? "0") ?? 0))
//        viewRangeSlider.upperValue = max
//        viewRangeSlider.lowerValue = min
//        viewRangeSlider.maximumValue = max
//        viewRangeSlider.minimumValue = min
//        viewRangeSlider.minimumDistance = 0.5
    }
    
//    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
//        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
//        let maxPrice = roundValue(value: (Double(rangeSlider.upperValue)))
//        let minPrice = roundValue(value: (Double(rangeSlider.lowerValue)))
//        if (maxPrice - minPrice) ==  viewRangeSlider.minimumDistance {
//            self.showAlertWithAction(title: "", message: "Max Price should be greter than minimum value") {
//
//            }
//        }
//
//        lblMaxPrice.text = "\(maxPrice)"
//        lblMinPrice.text = "\(minPrice)"
//    }
//
    func setupBrandDropDown() {
        
        var stringArray = [String]()
        stringArray.append("Select Brand")
        for i in 0..<(filterList?.filterData?[3].brand?.count ?? 0) {
            stringArray.append(filterList?.filterData?[3].brand?[i].name ?? "")
        }
        brandDropDown.dataSource = stringArray
    }
    
    func roundValue(value : Double) -> Double {
        
        return Double(round(100*value)/100)
    }
    
//MARK:- IBACTION METHODS
    
    @IBAction func clickedBtnFilter(_ sender: Any) {
        
        isFromSort = false
        isFromCategory = false
        isFromFilter = true
        page = 1
        viewSort.isHidden = true
        tableView1.isHidden = true
        viewSortFilter.isHidden = true
        viewFilter.isHidden = false
        getFilterList()
    }
    
    @IBAction func clickedBtnSort(_ sender: Any) {
        
        isFromSort = false
        isFromCategory = false
        isFromFilter = false
        page = 1
        viewSort.isHidden = false
        tableView1.isUserInteractionEnabled = false
        viewSortFilter.isUserInteractionEnabled = false
        tableView1.isHidden = false
        viewSortFilter.isHidden = false
        viewSortBackground.isHidden = false
        viewFilter.isHidden = true
        self.parentVC.viewSortBackground.isHidden = false
        parentVC.bottomBar.isHidden = true
        parentVC.constraintBottomBarHeight.constant = 0
        self.getSortList()
    }
    
    @IBAction func clickedBtnBrand(_ sender: Any) {
        
        brandDropDown.show()
        brandDropDown.selectionAction = { [weak self] (index, item) in
            self?.lblBrand.text = item
        }
    }
    
    @IBAction func clickedApplyFilter(_ sender: Any) {
        
        if lblBrand.text == "Select a Brand" {
            lblBrand.text = "Brand"
        }
        var coloroption = [String]()
        for i in 0..<colorOption.count {
            if colorOption[i] != "" {
                coloroption.append(colorOption[i])
            }
        }
        self.applyFilter(search: "", option: coloroption, brand: (lblBrand.text ?? ""), minprice: lblMinPrice.text ?? "", maxprice: lblMaxPrice.text ?? "", filterCategoryid: [], page: "1", categoryId: self.category.categoryID ?? "")
    }
}


//MARK:- UITableViewDelegate AND UITableViewDataSource
extension SubCategoryController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int?
        
        if tableView == tableView1 {
            count = isProductsScreen ? products.count : subCategories.count
        } else if tableView == viewTableViwSort {
            count = sortList?.sorts?.count ?? 0
        }
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell1 : UITableViewCell?
        
        if tableView == tableView1 {
            
            if isProductsScreen {
                let cell = self.tableView1.dequeueReusableCell(withIdentifier: "ProductViewCell") as! ProductViewCell
                
                cell.selectionStyle = .none
                cell.cellProductDelegate = self
                cell.nameLabel.text = products[indexPath.row].name
                cell.serialNumberLabel.text = products[indexPath.row].modelNo
                cell.inStockLabel.text = products[indexPath.row].stockStatus

                if products[indexPath.row].optionsAvailable ?? false {
                    
                    cell.lblPricePerCase.isHidden = false
                    cell.lblPricePerPiece.isHidden = false
                    cell.byCaseButton.isHidden = false
                    cell.lblPerCase.isHidden = false
                    cell.pricePerPiece.text = products[indexPath.row].options?.first?.productOptionValue?[0].price
                    cell.lblPerPiece.text = "/ " + (products[indexPath.row].options?.first?.productOptionValue?[0].name ?? "")
                    cell.pricePerCase.text = products[indexPath.row].options?.first?.productOptionValue?[1].price
                    cell.lblPerCase.text = "/ " + (products[indexPath.row].options?.first?.productOptionValue?[1].name ?? "")
                    
                } else {
                    cell.lblPricePerCase.isHidden = false
                    cell.lblPricePerPiece.isHidden = true
                    cell.byCaseButton.isHidden = true
                    cell.lblPerCase.isHidden = true
                    cell.pricePerCase.text = products[indexPath.row].price
                }

                if products[indexPath.row].isWishList {
                    cell.btnWishlist.setImage(UIImage(named: "addToWishlist.pdf"), for: UIControl.State.normal)
                } else {
                    cell.btnWishlist.setImage(UIImage(named: "Heart.pdf"), for: UIControl.State.normal)
                }
                
                if let thumb = products[indexPath.row].thumb {
                    let options = ImageLoadingOptions(
                        placeholder: UIImage(named: "Image Icon"),
                        transition: .fadeIn(duration: 0.0)
                    )
                    let url = URL(string: thumb)!
                    Nuke.loadImage(with: url, options: options, into: cell.productImage)
                    cell1 = cell
                }
                
            } else {
                let cell = self.tableView1.dequeueReusableCell(withIdentifier: "SubCategoryViewCell") as! SubCategoryViewCell
                cell.categoryItem = subCategories[indexPath.row]
                cell.selectionStyle = .none
                cell1 = cell
            }
            
        } else if tableView == viewTableViwSort {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "SortTableViewCell") as! SortTableViewCell
            cell2.lblName.text = sortList?.sorts?[indexPath.row].text
            if indexPath.row == selectedIndex {
                cell2.imageTick.isHidden = false
                cell2.lblName.textColor = Colors.hexColor(hex: "#F2A7BB")
            } else {
                cell2.imageTick.isHidden = true
                cell2.lblName.textColor = Colors.label
            }
            cell1 = cell2
        }
        
        return cell1 ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableView1 {
            
            if isProductsScreen {
                print("ProductViewCell")
            } else {
                parentVC.navigator.navigate(to: .subCategories(category: subCategories[indexPath.row], isCallFrom: "", wishlist: []))
            }
        } else if tableView == viewTableViwSort {
            
            let sort = sortList?.sorts?[indexPath.row].value ?? ""
            sortby = sort.components(separatedBy: "&").first ?? ""
            order = sort.components(separatedBy: "order=")[1]
            selectedIndex = indexPath.row
            isFromSort = true
            isFromCategory = false
            isFromFilter = false
            self.getSortProduct(search: "", sortBy: sortby, order: order, page: "1")
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if iscallFrom == "Settings" {
            return true
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("delete")
            let productId = products[indexPath.row].productID
            let custId = UserDefaults.standard.getCutomerID()
            self.removeWishList(productid: productId ?? "", customerId: custId)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == tableView1 {
            if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
                if indexPath == lastVisibleIndexPath && (page <= Int(subCategoriesData.totalPage ?? 0)) {
//                    page = page + 1
                    self.view.makeToast("loading more data")
                    if isFromCategory {
                        self.getSubCategories(page : "\(page)")
                        page = page + 1
                    } else if isFromSort {
                        self.getSortProduct(search: "", sortBy: sortby, order: order, page: "\(page)")
                        page = page + 1
                    } else if isFromFilter {
                        let search = parentVC.titleLabel.text ?? ""
                        var coloroption = [String]()
                        for i in 0..<colorOption.count {
                            if colorOption[i] != "" {
                                coloroption.append(colorOption[i])
                            }
                        }
                        self.applyFilter(search: search, option: colorOption, brand: (lblBrand.text ?? ""), minprice: lblMinPrice.text ?? "", maxprice: lblMaxPrice.text ?? "", filterCategoryid: [], page: "\(page)", categoryId: self.category.categoryID ?? "")
                        page = page + 1
                    }
                }
            }
        }
    }
}

//MARK:- ProductViewDelegate
extension SubCategoryController : ProductViewDelegate {
    
    func clickedProductName(cell : ProductViewCell) {
        
        let indexpath = tableView1.indexPath(for: cell)
        let productid = products[indexpath?.row ?? 0].productID ?? ""
        let productname = products[indexpath?.row ?? 0].name ?? ""
        self.tapOnProductName(productName: productname, productid: productid)
    }
    
    func clickedAddToWishlist(cell: ProductViewCell) {
        
        let indexpath = tableView1.indexPath(for: cell)
        let productid = products[indexpath?.row ?? 0].productID ?? ""
        self.addToWishList(productid: productid, index: indexpath?.row ?? 0)
    }
        
    func clickedAddToCart(cell: ProductViewCell) {
        
        let indexpath = tableView1.indexPath(for: cell)
        let productid = products[indexpath?.row ?? 0].productID ?? ""
        var option : String?
        let productoption = products[indexpath?.row ?? 0].options?.first?.productOptionID
        if products[indexpath?.row ?? 0].optionsAvailable ?? false {
            
            if !products[indexpath?.row ?? 0].isButtonCaseClicked {
                option = products[indexpath?.row ?? 0].options?.first?.productOptionValue?[0].productOptionValueID
            } else {
                option = products[indexpath?.row ?? 0].options?.first?.productOptionValue?[1].productOptionValueID
            }
        } else {
            option = nil
        }
        self.addToCart(productid: productid, quantity: String(productquantity), option: option ?? "", productOption: productoption ?? "")
    }
    
    
    func clickedbtnPlus(cell: ProductViewCell) {
        cell.quantityLabel.text = String((Int(cell.quantityLabel.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.quantityLabel.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus(cell: ProductViewCell) {
        
        if ((Int(cell.quantityLabel.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.quantityLabel.text = String((Int(cell.quantityLabel.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(cell.quantityLabel.text ?? "") ?? 0)
    }
        
    func clickedbtnByCase(cell: ProductViewCell, sender: UIButton) {
        
        let indexpath = tableView1.indexPath(for: cell)
        products[indexpath?.row ?? 0].isButtonCaseClicked = !products[indexpath?.row ?? 0].isButtonCaseClicked
        if !products[indexpath?.row ?? 0].isButtonCaseClicked {
            
            cell.lblByCase.text = "By Case"
            cell.imageViewByCase.image = UIImage(named: "byCase.pdf")
        } else {
            
            cell.lblByCase.text = "By Piece"
            cell.imageViewByCase.image = UIImage(named: "byPiece.pdf")
        }
    }
}

//MARK:- COLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS

extension SubCategoryController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == colorCollectionView {
            
            let selected = filterList?.filterData?[0].color?[indexPath.row].isSelected ?? false
            if selected {
                filterList?.filterData?[0].color?[indexPath.row].isSelected = false
                colorOption[indexPath.row] = ""
            } else {
                filterList?.filterData?[0].color?[indexPath.row].isSelected = true
                colorOption[indexPath.row] = filterList?.filterData?[0].color?[indexPath.row].optionValueID ?? ""
            }
            
            colorCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count : Int?
        if collectionView == colorCollectionView {
            count = filterList?.filterData?[0].color?.count
        }
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
       
        if collectionView == colorCollectionView {
            
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterColorCollectionViewCell", for: indexPath) as! FilterColorCollectionViewCell
            let hexCode = filterList?.filterData?[0].color?[indexPath.row].hexCode ?? ""
            cell2.viewColor.backgroundColor = Colors.hexColor(hex: hexCode)
            
            if filterList?.filterData?[0].color?[indexPath.row].isSelected ?? false {
                cell2.imgViewIcon.isHidden = false
            } else {
                cell2.imgViewIcon.isHidden = true
            }
            cell = cell2
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size : CGSize?
        if collectionView == colorCollectionView {
            
            size = CGSize(width: collectionView.layer.bounds.width/8 , height: collectionView.layer.bounds.height)
        }
        
        return size ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
