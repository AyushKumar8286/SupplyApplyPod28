//
//  APIClient.swift
//  SHNetworlLayer
//
//  Created by shashi on 1/19/19.
//  Copyright © 2019 shashi. All rights reserved.
//

import Foundation
import Alamofire

class SHRestClient{
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    
    @discardableResult
    private static func getRequest<T:Decodable>(route:APIRouteConfiguration, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        return AF.request(route)
            .responseJSON(completionHandler: { (response) in
                debugPrint(response.result)
            })
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                debugPrint(response.result)
                completion(response.result)
        }
        
    }
    
    
    @discardableResult
    private static func postRequest<T:Decodable>(route:APIRouteConfiguration, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        let params = route.parameters
        
        return AF.upload(multipartFormData: { multipartFormData in
            if let paramerters = params {
                for (key, value) in paramerters {
                    if let dataVal  = value as? Data{
                        if let fileType = paramerters["type"] as? String {
                            if fileType == "pdf" {
                                multipartFormData.append(dataVal, withName: key, fileName: "License.\(fileType)", mimeType: "application/png")
                            } else if fileType == "png" {
                                multipartFormData.append(dataVal, withName: key, fileName: "License.\(fileType)", mimeType: "image/png")
                            } else if fileType == "jpg" {
                                multipartFormData.append(dataVal, withName: key, fileName: "License.\(fileType)", mimeType: "image/png")
                            }
                        } else {
                            multipartFormData.append(dataVal, withName: key)
                        }
                    } else {
                        let dataStr = "\(value)"
                        multipartFormData.append(dataStr.data(using: .utf8)!, withName: key)
                    }
                }
            }
        }, with: route)
            .responseJSON(completionHandler: { (response) in
                debugPrint(response.result)
            })
            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
                debugPrint(response.result)
                completion(response.result)
        }
    }
    
    
    static func login(email: String, password: String, completion:@escaping (Result<User>)->Void) {
        postRequest(route: EndPoints.login(email: email, password: password), completion: completion)
    }
    
    static func signup(name: String, email: String, mobile: String, password: String, completion:@escaping (Result<User>)->Void) {
        postRequest(route: EndPoints.signup(name: name, email: email, mobile: mobile, password: password), completion: completion)
    }
    
    static func uploadLicense(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.licenseUpload(params: params), completion: completion)
    }
    
    static func requestOTP(email: String, completion:@escaping (Result<StringResponse>)->Void) {
        postRequest(route: EndPoints.requestOTP(email: email), completion: completion)
    }
    
    static func resetPassword(email: String, otp: String, password: String, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.resetPassword(email: email, otp: otp, password: password), completion: completion)
    }
    
    static func getCategories(completion:@escaping (Result<Categories>)->Void) {
        postRequest(route: EndPoints.getCategories, completion: completion)
    }
    
    static func getSubCategories(categoryId: String, page: String, option: String, completion:@escaping (Result<SubCategories>)->Void) {
        getRequest(route: EndPoints.subCategories(categoryId: categoryId, page: page, option: option), completion: completion)
    }
    
    static func logout(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.logout(params: params), completion: completion)
    }
    
    static func addToCart(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.addToCart(params: params), completion: completion)
    }
    
    static func wishlistAdd(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.wishlistAdd(params: params), completion: completion)
    }
    
    static func wishlistRemove(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.wishlistRemove(params: params), completion: completion)
    }
    
    static func getAllWishlist(params : Dictionary<String, Any>, completion:@escaping (Result<SubCategories>)->Void) {
        postRequest(route: EndPoints.wishlistList(params: params), completion: completion)
    }
    
    static func getProductDetail(params : Dictionary<String, Any>, completion:@escaping (Result<ProductInfo>)->Void) {
        postRequest(route: EndPoints.productDetail(params: params), completion: completion)
    }
    
    static func aboutUs(completion:@escaping (Result<AboutUs>)->Void) {
        postRequest(route: EndPoints.aboutUs, completion: completion)
    }
    
    static func faq(completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.faq, completion: completion)
    }
    
    static func accountInfo(params : Dictionary<String, Any>, completion: @escaping (Result<MyAccountInfo>)->Void) {
        postRequest(route: EndPoints.accountInfo(params: params), completion: completion)
    }
    
    static func logOut(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.logout(params: params), completion: completion)
    }
    
    static func getOrderList(params : Dictionary<String, Any>, completion:@escaping (Result<MyOrder>)->Void) {
        postRequest(route: EndPoints.orderListAPI(params: params), completion: completion)
    }
    
    static func getCartList(params : Dictionary<String, Any>, completion:@escaping (Result<CartListModel>)->Void) {
        postRequest(route: EndPoints.cartList(params: params), completion: completion)
    }
    
    static func editCartList(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.editCartList(params: params), completion: completion)
    }
    
    static func getCartCount(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.getCartCount(params: params), completion: completion)
    }
    
    static func deleteCartList(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.deleteCartList(params: params), completion: completion)
    }
    static func getDealList(categoryId: String, completion:@escaping (Result<DealList>)->Void) {
        getRequest(route: EndPoints.dealOfThedayAPI(categoryId: categoryId), completion: completion)
    }

    static func getSortList(completion:@escaping (Result<SortList>)->Void) {
        getRequest(route: EndPoints.sortList, completion: completion)
    }
    
    static func getSort(search: String, sortby: String, order : String,categoryId: String, page: String, completion:@escaping (Result<SubCategories>)->Void) {
        postRequest(route: EndPoints.sort(search: search, sortby: sortby, order: order, categoryId: categoryId, page: page), completion: completion)
    }
    
    static func getSearchList(params : Dictionary<String, Any>, completion:@escaping (Result<FilterList>)->Void) {
        postRequest(route: EndPoints.search(params: params), completion: completion)
    }
    
    static func getpaymentAddressList(params : Dictionary<String, Any>, completion:@escaping (Result<ShippingAddress>)->Void) {
        postRequest(route: EndPoints.getPaymentAddresslist(params: params), completion: completion)
    }
    
    static func addAddress(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.addAddress(params: params), completion: completion)
    }
        
    static func getAddressByFormId(params : Dictionary<String, Any>, completion:@escaping (Result<AddressData>)->Void) {
        postRequest(route: EndPoints.addressFetchOnBasisOfID(params: params), completion: completion)
    }
    
    static func getCountryList(completion:@escaping (Result<CountryList>)->Void) {
        getRequest(route: EndPoints.countryList, completion: completion)
    }
    
    static func getStateList(params : Dictionary<String, Any>, completion:@escaping (Result<StateList>)->Void) {
        postRequest(route: EndPoints.stateList(params: params), completion: completion)
    }
    static func getShippingMethodList(params : Dictionary<String, Any>, completion:@escaping (Result<ShippingList>)->Void) {
        postRequest(route: EndPoints.shippingMethodList(params: params), completion: completion)
    }
    
    static func submitShippingMethod(params : Dictionary<String, Any>, completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.submitShippingmethod(params: params), completion: completion)
    }
    
    static func getPaymentMethod(params : Dictionary<String, Any>, completion:@escaping (Result<PaymentMethodList>)->Void) {
        postRequest(route: EndPoints.paymentMethod(params: params), completion: completion)
    }
    
    static func submitPaymentMethod(params : Dictionary<String, Any>, completion:@escaping (Result<SubmitPaymentMethod>)->Void) {
        postRequest(route: EndPoints.submitPaymentMethodAndOrderOverview(params: params), completion: completion)
    }
    
    static func checkoutSuccess( completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.checkoutSuccess, completion: completion)
    }
    
    static func confirmPayment( completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.confirmPayment, completion: completion)
    }
    
    static func getfilter(params : Dictionary<String, Any>,completion:@escaping (Result<FilterData>)->Void) {
        postRequest(route: EndPoints.getFilters(params: params), completion: completion)
    }
    
    static func applyFilter(search: String, option : [String], brand : String, minprice : String, maxprice : String, filterCategoryid : [String], page : String, categoryId : String, completion:@escaping (Result<SubCategories>)->Void) {
        getRequest(route: EndPoints.applyFilter(search: search, option: option, brand: brand, minprice: minprice, maxprice: maxprice, filterCategoryid: filterCategoryid, page: page, categoryId: categoryId), completion: completion)
    }
    
    static func stripeConfirm(params : Dictionary<String, Any>,completion:@escaping (Result<GenericResponse>)->Void) {
        postRequest(route: EndPoints.stripeConfirm(params: params), completion: completion)
    }
}


struct ProductionServer {
    public static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}


enum ContentType: String {
    case json = "application/json"
    case form = "multipart/form-data"
    
}
