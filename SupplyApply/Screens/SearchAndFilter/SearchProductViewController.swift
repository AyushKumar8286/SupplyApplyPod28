//
//  SearchProductViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 11/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import Nuke
import DropDown

class SearchProductViewController: CustomViewController {
    
    
    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var subCategories : SubCategories?
    var product : [Product] = []
    var sortList : SortList?
    var filterList : FilterData?
    var productquantity = 1
    var isLastTable = false
    var selectedIndex = -1
    let brandDropDown = DropDown()
    var categoryOption = [String]()
    var colorOption = [String]()
    var sortby = ""
    var order = ""
    var isFromSearch = true
    var isFromSort = false
    var isFromFilter = false
    var page = 1
    
    //MARK:- IBOUTLET
    @IBOutlet weak var viewTableView: UITableView!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var viewFilterAndSort: UIView!
    @IBOutlet weak var viewSortTableView: UITableView!
    @IBOutlet weak var constraintViewSortHeight: NSLayoutConstraint!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
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
    @IBOutlet var viewContent: UIView!
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    //MARK:- PRIVATE METHODS
    
    private func setUpView() {
    
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        
        self.parentVC.btnDealOfTheDay.setImage(UIImage(named: "icon-quick-shop cross.pdf"), for: .normal)
        viewTableView.register(UINib(nibName: "SearchproductTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchproductTableViewCell")
        viewTableView.delegate = self
        viewTableView.dataSource = self
        viewSortTableView.register(UINib(nibName: "SortTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SortTableViewCell")
        viewSortTableView.delegate = self
        viewSortTableView.dataSource = self
        menuCollectionView.register(UINib(nibName: "FliterMenuCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FliterMenuCollectionViewCell")
        colorCollectionView.register(UINib(nibName: "FilterColorCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FilterColorCollectionViewCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        viewSort.isHidden = true
        viewFilter.isHidden = true
        getSearchProduct(search: "", sortBy: "", order: "", page: "1")
//        viewRangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChangedFilter(_:)), for: .valueChanged)
        viewApplyFilter.clipsToBounds = true
        viewApplyFilter.layer.cornerRadius = viewApplyFilter.layer.bounds.height/2
        viewSortBackground.isHidden = true
        viewSortBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        viewFilterAndSort.addDesign(cornerRadius: 30, shadowWidth: 0, shadowHeight: 2, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        viewFilterAndSort.clipsToBounds = false
        viewFilterAndSort.layer.masksToBounds = false
    }
    
    func getSearchProduct(search : String,sortBy : String, order: String, page: String) {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getSort(search: search, sortby: "", order: "", categoryId: "", page: page) { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        if page == "1" {
                            self.subCategories = response
                            self.product = []
                        }
                        self.product.append(contentsOf: response.products ?? [])

                        self.viewTableView.reloadData()
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

                        self.parentVC.getCartCount(customerId : UserDefaults.standard.getCutomerID())
                        self.view.makeToast(response.message)
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
    
    func getSortProduct(search : String,sortBy : String, order: String, page: String) {
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getSort(search: search, sortby: sortBy, order: order, categoryId: "", page: page) { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
//                        self.subCategories = response
                        if page == "1" {
                            self.subCategories = response
                            self.product = []
                        }
                        self.product.append(contentsOf: response.products ?? [])
                        self.viewSort.isHidden = true
                        self.viewSortBackground.isHidden = true
                        self.viewTableView.isUserInteractionEnabled = true
                        self.viewFilterAndSort.isUserInteractionEnabled = true
                        self.viewFilter.isHidden = true
                        self.parentVC.viewSortBackground.isHidden = true
                        self.parentVC.bottomBar.isHidden = false
                        self.parentVC.constraintBottomBarHeight.constant = 70
                        self.viewTableView.reloadData()
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
                        self.viewSortTableView.reloadData()
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
    
    func getFilterList() {
        if SHRestClient.isConnectedToInternet() {
            
            let params : [String: Any] = [
                "filter_type" : "search"
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
                        for _ in 0..<(self.filterList?.filterData?[4].categories?.count ?? 0) {
                            self.categoryOption.append("")
                        }
                        self.menuCollectionView.reloadData()
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
            SHRestClient.applyFilter(search: search, option: option, brand: brand, minprice: minprice, maxprice: maxprice, filterCategoryid: filterCategoryid, page: "1", categoryId: "", completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        if page == "1" {
                            self.subCategories = response
                            self.product = []
                        }
                        
                        self.product = response.products ?? []
                        self.viewFilter.isHidden = true
                        self.viewTableView.isHidden = false
                        self.viewFilterAndSort.isHidden = false
                        self.viewTableView.reloadData()
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
    
//    @objc func rangeSliderValueChangedFilter(_ rangeSlider: RangeSlider) {
//        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
//        let maxPrice = roundValue(value: (Double(rangeSlider.upperValue)))
//        let minPrice = roundValue(value: (Double(rangeSlider.lowerValue)))
//        if (maxPrice - minPrice) ==  viewRangeSlider.minimumDistance {
//            self.showAlertWithAction(title: "", message: "Max Price should be greter than minimum value") {
//            }
//        }
//        
//        lblMaxPrice.text = "\(maxPrice)"
//        lblMinPrice.text = "\(minPrice)"
//    }
    
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
    
    //MARK:- IBOUTLET Action Methods
    @IBAction func clickedBtnFilter(_ sender: Any) {
        
        isFromSort = false
        isFromSearch = false
        isFromFilter = true
        page = 1
        viewFilter.isHidden = false
        viewSort.isHidden = true
        viewTableView.isHidden = true
        viewFilterAndSort.isHidden = true
        getFilterList()
    }

    @IBAction func clickedBtnSort(_ sender: Any) {
        
        isFromSort = true
        isFromSearch = false
        isFromFilter = false
        viewSort.isHidden = false
        viewSortBackground.isHidden = false
        page = 1
        viewTableView.isUserInteractionEnabled = false
        viewFilterAndSort.isUserInteractionEnabled = false
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
        
    @IBAction func btnApplyFilter(_ sender: Any) {
        let search = parentVC.titleLabel.text ?? ""
        if lblBrand.text == "Select a Brand" {
            lblBrand.text = "Brand"
        }
        var coloroption = [String]()
        for i in 0..<colorOption.count {
            if colorOption[i] != "" {
                coloroption.append(colorOption[i])
            }
        }
        var categoryoption = [String]()
        for i in 0..<categoryOption.count {
            if categoryOption[i] != "" {
                categoryoption.append(categoryOption[i])
            }
        }
        self.applyFilter(search: search, option: coloroption, brand: (lblBrand.text ?? ""), minprice: lblMinPrice.text ?? "", maxprice: lblMaxPrice.text ?? "", filterCategoryid: categoryoption, page: "1", categoryId: "")
    }
}


//MARK:- TABLEVIEW DELEGATE AND DATA SOURCE
extension SearchProductViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        
        if tableView == viewTableView {
            if ((product.count)%2) == 0 {
                return ((product.count)/2)
            } else {
                return (((product.count) - 1)/2) + 1
            }
        } else if tableView == viewSortTableView {
            count = sortList?.sorts?.count ?? 0
        }
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell1 : UITableViewCell?
        
        if tableView == viewTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchproductTableViewCell") as! SearchproductTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.lblProductName1.text = product[indexPath.row * 2].name
            cell.lblModel1.text = product[indexPath.row * 2].modelNo
            cell.lblInStock1.text = product[indexPath.row * 2].stockStatus
            let option1 = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            if let url1 = URL(string: product[indexPath.row * 2].thumb ?? "") {
                Nuke.loadImage(with: url1, options: option1, into: cell.imageViewProduct1)
            } else {
                cell.imageViewProduct1?.image = UIImage(named: "Image Icon")
            }

            if product[indexPath.row * 2].optionsAvailable ?? false {
                
                cell.viewByCase1.isHidden = false
                cell.lblCDNPiece1.isHidden = false
                cell.lblPriceByCase1.isHidden = false
                cell.lblPriceByCase1.isHidden = false
                cell.lbPriceByPiece1.text = product[indexPath.row * 2].options?.first?.productOptionValue?[0].price ?? ""
                cell.lblPerPiece1.isHidden = false
                cell.lblPriceByCase1.text = product[indexPath.row * 2].options?.first?.productOptionValue?[1].price ?? ""
                cell.lblPerCase1.isHidden = false
                
            } else {
                cell.viewByCase1.isHidden = true
                cell.lbPriceByPiece1.text = product[indexPath.row * 2].price
                cell.lblCDNPiece1.isHidden = true
                cell.lblPerPiece1.isHidden = true
                cell.lblPriceByCase1.isHidden =  true
                cell.lblPerCase1.isHidden = true
            }
            
            if ((((product.count)%2) != 0) && (indexPath.row*2 + 1 == product.count)) {
                
                cell.viewRight.isHidden = true
                
            } else {
                cell.viewRight.isHidden = false
                cell.lblProductName2.text = product[(indexPath.row * 2) + 1].name
                cell.lblInStock2.text = product[(indexPath.row * 2) + 1].stockStatus
                let option2 = ImageLoadingOptions(
                    placeholder: UIImage(named: "Image Icon"),
                    transition: .fadeIn(duration: 0.0)
                )
                
                if let url2 = URL(string: product[(indexPath.row * 2) + 1].thumb ?? "") {
                    Nuke.loadImage(with: url2, options: option2, into: cell.imageViewProduct2)
                } else {
                    cell.imageViewProduct2?.image = UIImage(named: "Image Icon")
                }
                if product[(indexPath.row * 2) + 1].optionsAvailable ?? false {
                    
                    cell.viewByCase2.isHidden = false
                    cell.lblCDNPiece2.isHidden = false
                    cell.lblPriceByCase1.isHidden = false
                    cell.lblPriceByCase1.isHidden = false
                    cell.lbPriceByPiece2.text = product[(indexPath.row * 2) + 1].options?.first?.productOptionValue?[0].price ?? ""
                    cell.lblPerPiece2.isHidden = false
                    cell.lblPriceByCase2.text = product[(indexPath.row * 2) + 1].options?.first?.productOptionValue?[1].price ?? ""
                    cell.lblPerCase2.isHidden = false
                } else {
                    cell.viewByCase2.isHidden = true
                    cell.lbPriceByPiece2.text = product[(indexPath.row * 2) + 1].price
                    cell.lblCDNPiece2.isHidden = true
                    cell.lblPerPiece2.isHidden = true
                    cell.lblPriceByCase2.isHidden =  true
                    cell.lblPerCase2.isHidden = true
                }
            }
            
            cell1 = cell
        } else if tableView == viewSortTableView {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "SortTableViewCell") as! SortTableViewCell
            cell2.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == viewSortTableView {
            
            let sort = sortList?.sorts?[indexPath.row].value ?? ""
            sortby = sort.components(separatedBy: "&").first ?? ""
            order = sort.components(separatedBy: "order=")[1]
            selectedIndex = indexPath.row
            self.getSortProduct(search: parentVC.titleLabel.text ?? "", sortBy: sortby, order: order, page: "1")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == viewTableView {
            if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
                if indexPath == lastVisibleIndexPath && (page <= Int(subCategories?.totalPage ?? 0)) {
                    page = page + 1
                    self.view.makeToast("loading more data")
                    if isFromSearch {
                        self.getSearchProduct(search: "", sortBy: "", order: "", page: "\(page)")
                    } else if isFromSort {
                        self.getSortProduct(search: "", sortBy: sortby, order: order, page: "\(page)")
                    } else if isFromFilter {
                        let search = parentVC.titleLabel.text ?? ""
                        var coloroption = [String]()
                        for i in 0..<colorOption.count {
                            if colorOption[i] != "" {
                                coloroption.append(colorOption[i])
                            }
                        }
                        var categoryoption = [String]()
                        for i in 0..<categoryOption.count {
                            if categoryOption[i] != "" {
                                categoryoption.append(categoryOption[i])
                            }
                        }
                        self.applyFilter(search: search, option: coloroption, brand: (lblBrand.text ?? ""), minprice: lblMinPrice.text ?? "", maxprice: lblMaxPrice.text ?? "", filterCategoryid: categoryoption, page: "1", categoryId: "")
                    }
                }
            }
        }
    }
}


//MARK:- DealTableViewDelegate
extension SearchProductViewController : SearchproductViewDelegate {
    
    func clickedbtnByCase1(cell: SearchproductTableViewCell, sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !(sender.isSelected) {
            
            cell.lblByCase1.text = "By Case"
            cell.imageByCase1.image = UIImage(named: "byCase.pdf")
        } else {
            
            cell.lblByCase1.text = "By Piece"
            cell.imageByCase1.image = UIImage(named: "byPiece.pdf")
        }
    }
    
    func clickedbtnPlus1(cell: SearchproductTableViewCell) {
        
        cell.lblQuantity1.text = String((Int(cell.lblQuantity1.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.lblQuantity1.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus1(cell: SearchproductTableViewCell) {
        if ((Int(cell.lblQuantity1.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.lblQuantity1.text = String((Int(cell.lblQuantity1.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(cell.lblQuantity1.text ?? "") ?? 0)
    }
    
    func clickedbtnAddToCart1(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = product[(indexpath?.row ?? 0) * 2].productID ?? ""
        var option : String?
        let productoption = product[(indexpath?.row ?? 0) * 2].options?.first?.productOptionID
        if product[(indexpath?.row ?? 0) * 2].optionsAvailable ?? false {
            
            if !(product[(indexpath?.row ?? 0) * 2].isButtonCaseClicked) {
                option = product[(indexpath?.row ?? 0) * 2].options?.first?.productOptionValue?[0].productOptionValueID
            } else {
                option = product[(indexpath?.row ?? 0) * 2].options?.first?.productOptionValue?[1].productOptionValueID
            }
        } else {
            option = nil
        }
        self.addToCart(productid: productid, quantity: String(productquantity), option: option ?? "", productOption: productoption ?? "")
    }
    
    func clickedbtnProductImage1(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
        let productname = product[(indexpath?.row ?? 0)*2].name ?? ""
        let productModel = product[(indexpath?.row ?? 0)*2].modelNo ?? ""
        let productThumb = product[(indexpath?.row ?? 0)*2].thumb ?? ""
        self.parentVC.navigator.navigate(to: .productImage(productName: productname, productModel: productModel, productImage: productThumb))
    }
    
    func clickedbtnProductName1(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = product[(indexpath?.row ?? 0)*2].productID ?? ""
        let productname = product[(indexpath?.row ?? 0)*2].name ?? ""
        UserDefaults.standard.setProductID(value: productid)
        UserDefaults.standard.setProductName(value: productname)
        self.parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
    
    func clickedbtnByCase2(cell: SearchproductTableViewCell, sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !(sender.isSelected) {
            
            cell.lblByCase2.text = "By Case"
            cell.imageByCase2.image = UIImage(named: "byCase.pdf")
        } else {
            
            cell.lblByCase2.text = "By Piece"
            cell.imageByCase2.image = UIImage(named: "byPiece.pdf")
        }
    }
    
    func clickedbtnPlus2(cell: SearchproductTableViewCell) {
        cell.lblQuantity2.text = String((Int(cell.lblQuantity2.text ?? "") ?? 0) + 1)
        productquantity = (Int(cell.lblQuantity2.text ?? "") ?? 0)
    }
    
    func clickedbtnMinus2(cell: SearchproductTableViewCell) {
        if ((Int(cell.lblQuantity2.text ?? "") ?? 0) == 1) {
            return
        } else {
            cell.lblQuantity2.text = String((Int(cell.lblQuantity2.text ?? "") ?? 0) - 1)
        }
        
        productquantity = (Int(cell.lblQuantity2.text ?? "") ?? 0)
    }
    
    func clickedbtnAddToCart2(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
        let productid = product[((indexpath?.row ?? 0) * 2) + 1].productID ?? ""
        var option : String?
        let productoption = product[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionID
        if product[((indexpath?.row ?? 0) * 2) + 1].optionsAvailable ?? false {
            
            if !(product[((indexpath?.row ?? 0) * 2) + 1].isButtonCaseClicked) {
                option = product[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionValue?[0].productOptionValueID
            } else {
                option = product[((indexpath?.row ?? 0) * 2) + 1].options?.first?.productOptionValue?[1].productOptionValueID
            }
        } else {
            option = nil
        }
        self.addToCart(productid: productid, quantity: String(productquantity), option: option ?? "", productOption: productoption ?? "")
    }
    
    func clickedbtnProductImage2(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
        let productname = product[((indexpath?.row ?? 0) * 2) + 1].name ?? ""
        let productModel = product[((indexpath?.row ?? 0) * 2) + 1].modelNo ?? ""
        let productThumb = product[((indexpath?.row ?? 0) * 2) + 1].thumb ?? ""
        self.parentVC.navigator.navigate(to: .productImage(productName: productname, productModel: productModel, productImage: productThumb))
    }
    
    func clickedbtnProductName2(cell: SearchproductTableViewCell) {
        let indexpath = viewTableView.indexPath(for: cell)
            let productid = product[((indexpath?.row ?? 0)*2) + 1].productID ?? ""
            let productname = product[((indexpath?.row ?? 0)*2) + 1].name ?? ""
            UserDefaults.standard.setProductID(value: productid)
            UserDefaults.standard.setProductName(value: productname)
            self.parentVC.navigator.navigate(to: .productInfo(productName: productname, productId: productid))
    }
}

//MARK:- COLLECTIONVIEW DELEGATE AND DATA SOURCE METHODS

extension SearchProductViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuCollectionView {
            
            let selected = filterList?.filterData?[4].categories?[indexPath.row].isSelected ?? false
            
            if selected {
                filterList?.filterData?[4].categories?[indexPath.row].isSelected = false
                categoryOption[indexPath.row] = ""
            } else {
                filterList?.filterData?[4].categories?[indexPath.row].isSelected = true
                categoryOption[indexPath.row] = filterList?.filterData?[4].categories?[indexPath.row].categoryID ?? ""
                
            }
            menuCollectionView.reloadData()
            
        } else if collectionView == colorCollectionView {
            
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
        if collectionView == menuCollectionView {
            count = filterList?.filterData?[4].categories?.count
            
        } else if collectionView == colorCollectionView {
            count = filterList?.filterData?[0].color?.count
        }
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : UICollectionViewCell?
       
        if collectionView == menuCollectionView {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "FliterMenuCollectionViewCell", for: indexPath) as! FliterMenuCollectionViewCell
            cell1.lblCategoryName.text = filterList?.filterData?[4].categories?[indexPath.row].name
            let option1 = ImageLoadingOptions(
                placeholder: UIImage(named: "Image Icon"),
                transition: .fadeIn(duration: 0.0)
            )
            if let url1 = URL(string: filterList?.filterData?[4].categories?[indexPath.row].thumb ?? "") {
                Nuke.loadImage(with: url1, options: option1, into: cell1.imgViewCategory)
            } else {
                cell1.imgViewCategory?.image = UIImage(named: "Image Icon")
            }
            
            if filterList?.filterData?[4].categories?[indexPath.row].isSelected ?? false {
                cell1.viewContent.backgroundColor = Colors.lightTint
            } else {
                cell1.viewContent.backgroundColor = Colors.secondaryBackground
            }
                        
            cell = cell1
            
        } else if collectionView == colorCollectionView {
            
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
        if collectionView == menuCollectionView {
            
            size = CGSize(width: collectionView.layer.bounds.width/5 , height: collectionView.layer.bounds.height)
        } else if collectionView == colorCollectionView {
            
            size = CGSize(width: collectionView.layer.bounds.width/8 , height: collectionView.layer.bounds.height)
        }
        
        return size ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
