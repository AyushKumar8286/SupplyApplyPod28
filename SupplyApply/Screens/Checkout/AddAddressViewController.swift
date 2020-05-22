//
//  AddAddressViewController.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import UIKit
import DropDown

class AddAddressViewController: CustomViewController {

    
    //MARK:- VARIABLE
    var parentVC : AnimatedAppTabBar!
    var imageArray = ["icon-location.pdf","icon-delivery.pdf","icon-payment.pdf","icon-summary.pdf"]
    var addressResponse : GenericResponse?
    var addressbyId : [AddressIdData] = []
    var countryList : [Country] = []
    var stateList : [State] = []
    var countryId : String?
    var zoneId : String?
    var countryIndex : Int?
    var stateIndex : Int?
    var countryName : String?
    var stateName : String?
    let countryDropDown = DropDown()
    let stateDropDown = DropDown()
    var primaryAddress = true
    var addressId : String?
    var isCountryChange = false
    
    //MARK:- IBOUTLET
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var txtViewStreet: UITextView!
    @IBOutlet weak var viewDropDownCountry: UIView!
    
    @IBOutlet weak var viewDropDownState: UIView!
    @IBOutlet weak var lblTown: UITextField!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblPincode: UITextField!
    @IBOutlet weak var lblTopName: UILabel!
    @IBOutlet weak var lblTopHouse: UILabel!
    @IBOutlet weak var lblTopTown: UILabel!
    @IBOutlet weak var lblTopPincode: UILabel!
    @IBOutlet weak var lblPincodeLength: UILabel!
    @IBOutlet weak var viewContinue: UIView!
    
    
    //MARK:- VIEWCONTROLLER LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentViewController = self.parent as? AnimatedAppTabBar {
            self.parentVC = parentViewController
        }
        if UserDefaults.standard.getisCallFor() == "Shipping" {
            addressId = UserDefaults.standard.getShipAddressId()
            self.parentVC.titleLabel.text = "Add Shipping Address"
        } else if UserDefaults.standard.getisCallFor() == "Billing" {
            addressId = UserDefaults.standard.getBillAddressId()
            self.parentVC.titleLabel.text = "Add Billing Address"
        }
        getAddressByFormId(customerId: "", addressId: addressId ?? "")
    }
    
    //MARK:- PRIVATE METHODS
    private func setUpView() {
        
        parentVC.bottomBar.isHidden = true
        parentVC.constraintBottomBarHeight.constant = 0
        self.getCountryList()
        self.getStateList(countryId: countryId ?? "")
        lblName.text = addressbyId.first?.firstname
        txtViewStreet.text = addressbyId.first?.address1
        lblTown.text = addressbyId.first?.firstname
        lblCountry.text = addressbyId.first?.countryName
        lblState.text = stateName
        lblPincode.text = addressbyId.first?.postcode
        lblPincodeLength.text = "\(addressbyId.first?.postcode?.count ?? 0)/6"
        lblName.delegate = self
        lblTown.delegate = self
        lblPincode.delegate = self
        txtViewStreet.delegate = self
        viewContinue.clipsToBounds = true
        viewContinue.layer.cornerRadius = viewContinue.bounds.height/2
        
        // The view to which the drop down will appear on
        countryDropDown.anchorView = viewDropDownCountry
        countryDropDown.direction = .any
        countryDropDown.dismissMode = .automatic
        stateDropDown.anchorView = viewDropDownState
        stateDropDown.direction = .any
        stateDropDown.dismissMode = .automatic
        DropDown.appearance().textColor = UIColor.red.withAlphaComponent(0.5)
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        
    }
    
    private func addAddress(customerId:String, firstName : String, address1:String, city:String, postcode:String, zoneID:String, countryId:String, defaul:Bool) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID(),
                "firstname" : firstName,
                "address_1" : address1,
                "city" : city,
                "postcode": postcode,
                "zone_id" : zoneID,
                "country_id" : countryId,
                "default" : defaul
            ]
            
            SHRestClient.addAddress(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.addressResponse = response
                        self.view.makeToast(response.message)
                        self.parentVC.navigator.navigate(to: .shipping)
//                        self.loadShippingView()
                        debugPrint(response)
                    } else {
                        self.view.makeToast(response.message)
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
    
    func getAddressByFormId(customerId:String, addressId:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "customer_id" : UserDefaults.standard.getCutomerID(),
                "address_id" : addressId
            ]
            
            SHRestClient.getAddressByFormId(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.addressbyId = response.data ?? []
                        self.countryId = response.data?.first?.countryID
                        self.countryName = response.data?.first?.countryName
                        self.stateName = response.data?.first?.stateName
                        self.setUpView()
                        debugPrint(response)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    //     self.parentVC.showToast(message : "Failed to load data.", type: .failure)
                    self.view.makeToast("Failed to load data.")
                }
            })
        } else {
            self.showNoInternetWarning()
        }
    }
    
    func getCountryList() {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            SHRestClient.getCountryList(completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.countryList = response.countries ?? []
                        self.setupCountryDropDown()
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
    
    func getStateList(countryId:String) {
        
        if SHRestClient.isConnectedToInternet() {
            
            self.showLoading(isLoading: true)
            let params : [String: Any] = [
                "country_id" : countryId
            ]
            
            SHRestClient.getStateList(params: params , completion: { (result) in
                self.showLoading(isLoading: false)
                switch result {
                case .success(let response):
                    if response.success ?? false {
                        
                        self.viewDropDownState.isHidden = false
                        self.stateList = response.states ?? []
                        
                        if self.isCountryChange {
                            self.stateName = self.stateList.first?.name
                            self.zoneId = self.stateList.first?.zoneID
                        } else {
                            for i in 0..<(self.stateList.count) {
                                if self.stateName == self.stateList[i].name {
                                    self.zoneId = self.stateList[i].zoneID
                                }
                            }
                        }
                        
                        self.setupStateDropDown()
                        debugPrint(response)
                    } else {
                        self.viewDropDownState.isHidden = true
                        self.view.makeToast(response.message)
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
    
    func setupCountryDropDown() {
        
        var stringArray = [String]()
        for i in 0..<(countryList.count) {
            stringArray.append(countryList[i].name ?? "")
            
            if countryName == countryList[i].name {
                countryIndex = i
            }
        }
        countryDropDown.dataSource = stringArray
    }
    
    func setupStateDropDown() {
        
        lblState.text = stateName
        var stringArray = [String]()
        for i in 0..<(stateList.count) {
            stringArray.append(stateList[i].name ?? "")
            
//            if stateName == stateList[i].name {
//                countryIndex = i
//            }
        }
        stateDropDown.dataSource = stringArray
        stateDropDown.reloadAllComponents()
    }
    
    func validateUserInput()-> Bool {
        
        let isValidName = Validator.isValidString(lblName.text ?? "")
        let isValidHouse = Validator.isValidString(txtViewStreet.text ?? "")
        let isValidTown = Validator.isValidString(lblTown.text ?? "")
        let isValidPincode = Validator.isValidString(lblPincode.text ?? "")
        
        if !isValidName {
            self.view.makeToast("Please enter a Name.")
            return false
        } else  if !isValidHouse {
            self.view.makeToast("Please enter House/locality/street.")
            return false
        } else if !isValidTown {
            self.view.makeToast("Please enter Town.")
            return false
        } else  if !isValidPincode {
            self.view.makeToast("Please enter a Pincode.")
            return false
        } else {
            return true
        }
    }
    
    //MARK:- IBACTION METHODS
    @IBAction func clickedBtnPrimary(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            primaryAddress = false
        } else {
            primaryAddress = true
        }
    }
    
    @IBAction func clickedBtnBottom(_ sender: Any) {
        
        if validateUserInput() {
            
            self.addAddress(customerId: UserDefaults.standard.getCutomerID(), firstName: lblName.text ?? "", address1: txtViewStreet.text ?? "", city: lblTown.text ?? "", postcode: lblPincode.text ?? "", zoneID: zoneId ?? "", countryId: countryId ?? "", defaul: primaryAddress)
        }
    }
    
    @IBAction func clickedBtnDropDownCountry(_ sender: Any) {
        
        countryDropDown.show()
//        countryDropDown.selectRow(countryIndex ?? 0)
        countryDropDown.selectionAction = { [weak self] (index, item) in
            self?.lblCountry.text = item
            self?.countryId = self?.countryList[index].countryID
            self?.countryIndex = index
            self?.countryName = item
            self?.getStateList(countryId: self?.countryId ?? "")
            self?.isCountryChange = true
        }
    }
    
    @IBAction func clickedBtnDropDownState(_ sender: Any) {
        
        stateDropDown.show()
        //        stateDropDown.selectRow(countryIndex ?? 0)
        stateDropDown.selectionAction = { [weak self] (index, item) in
            self?.lblState.text = item
            self?.stateIndex = index
            self?.stateName = item
            self?.zoneId = self?.stateList[index].zoneID
        }
    }
}

extension AddAddressViewController : UITextViewDelegate, UITextFieldDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        lblTopName.textColor = Colors.label
        lblTopHouse.textColor = UIColor.red.withAlphaComponent(0.5)
        lblTopTown.textColor = Colors.label
        lblTopPincode.textColor = Colors.label
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            
        case 1:
            lblTopName.textColor = UIColor.red.withAlphaComponent(0.5)
            lblTopHouse.textColor = Colors.label
            lblTopTown.textColor = Colors.label
            lblTopPincode.textColor = Colors.label
        case 2:
            lblTopName.textColor = Colors.label
            lblTopHouse.textColor = Colors.label
            lblTopTown.textColor = UIColor.red.withAlphaComponent(0.5)
            lblTopPincode.textColor = Colors.label
        case 3:
            lblTopName.textColor = Colors.label
            lblTopHouse.textColor = Colors.label
            lblTopTown.textColor = Colors.label
            lblTopPincode.textColor = UIColor.red.withAlphaComponent(0.5)
        default:
            break
        }
        return true
    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 3:
            
            lblPincodeLength.text = "\((textField.text?.count ?? 0))/6"
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            break
        }
     
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.tag == 3 {
            lblPincodeLength.text = "\((textField.text?.count ?? 0))/6"
        }
    }
}
