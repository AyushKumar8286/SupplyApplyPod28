
import Foundation
import Alamofire

enum EndPoints : APIRouteConfiguration{
    
    var path: String {
        return ""
    }
    
    case login(email: String, password: String)
    case signup(name: String, email: String, mobile: String, password: String)
    case licenseUpload(params : Dictionary<String, Any>)
    case requestOTP(email: String)
    case resetPassword(email: String, otp: String, password: String)
    case getCategories
    case subCategories(categoryId: String, page : String, option: String)
    case search(params : Dictionary<String, Any>)
    case getFilters(params : Dictionary<String, Any>)
    case ordersList
    case orderInfo
    case accountInfo(params : Dictionary<String, Any>)
    case accountEdit
    case productDetail(params : Dictionary<String, Any>)
    case wishlistRemove(params : Dictionary<String, Any>)
    case wishlistAdd(params : Dictionary<String, Any>)
    case wishlistList(params : Dictionary<String, Any>)
    case getPaymentAddresslist(params : Dictionary<String, Any>)
    case addAddress(params : Dictionary<String, Any>)
    case shippingMethodList(params : Dictionary<String, Any>)
    case paymentAddress
    case countryList
    case stateList(params : Dictionary<String, Any>)
    case paymentMethod(params : Dictionary<String, Any>)
    case addressFetchOnBasisOfID(params : Dictionary<String, Any>)
    case addressList
    case dealOfThedayAPI(categoryId: String)
    case submitShippingmethod(params : Dictionary<String, Any>)
    case submitPaymentMethodAndOrderOverview(params : Dictionary<String, Any>)
    case orderListAPI(params : Dictionary<String, Any>)
    case addToCart(params : Dictionary<String, Any>)
    case aboutUs
    case faq
    case logout(params : Dictionary<String, Any>)
    case cartList(params : Dictionary<String, Any>)
    case editCartList(params : Dictionary<String, Any>)
    case getCartCount(params : Dictionary<String, Any>)
    case deleteCartList(params : Dictionary<String, Any>)
    case sortList
    case sort(search: String, sortby : String, order : String, categoryId : String, page : String)
    case checkoutSuccess
    case confirmPayment
    case applyFilter(search: String, option : [String], brand : String, minprice : String, maxprice : String, filterCategoryid : [String], page : String, categoryId : String)
    case stripeConfirm(params : Dictionary<String, Any>)
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login    :
            return .post
        case .signup :
            return .post
        case .licenseUpload :
            return .post
        case .requestOTP :
            return .post
        case .resetPassword :
            return .post
        case .getCategories :
            return .post
        case .subCategories :
            return .get
        case .search :
            return .post
        case .getFilters :
            return .post
        case .ordersList :
            return .post
        case .orderInfo    :
            return .post
        case .accountInfo :
            return .post
        case .accountEdit :
            return .post
        case .productDetail :
            return .post
        case .wishlistRemove :
            return .post
        case .wishlistAdd :
            return .post
        case .wishlistList :
            return .post
        case .getPaymentAddresslist    :
            return .post
        case .addAddress :
            return .post
        case .shippingMethodList :
            return .post
        case .paymentAddress :
            return .post
        case .countryList :
            return .get
        case .stateList :
            return .post
        case .paymentMethod :
            return .post
        case .addressFetchOnBasisOfID :
            return .post
        case .addressList :
            return .post
        case .dealOfThedayAPI :
            return .get
        case .submitShippingmethod :
            return .post
        case .submitPaymentMethodAndOrderOverview :
            return .post
        case .orderListAPI :
            return .post
        case .addToCart :
            return .post
        case .aboutUs :
            return .get
        case .faq :
            return .get
        case .logout :
            return .post
        case .cartList :
            return .post
        case .editCartList :
            return .post
        case .getCartCount :
            return .post
        case .deleteCartList :
            return .post
        case .sortList :
            return .get
        case .sort :
            return .get
        case .checkoutSuccess :
            return .get
        case .confirmPayment :
            return .get
        case .applyFilter :
            return .get
        case .stripeConfirm :
            return .post
        }
    }
    
    // MARK: - Path
    var queryParams : [URLQueryItem]? {
        switch self {
        case .login :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/login")]
        case .signup :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/register")]
        case .licenseUpload :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/licenseUpload")]
        case .requestOTP :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/forgotpassword")]
        case .resetPassword :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/checkPasswordOtp")]
        case .getCategories :
            return [URLQueryItem(name :  "route", value :  "openapi/category/categories")]
        case .subCategories(let categoryId, let page, let option) :
            return [
                URLQueryItem(name :  "route", value :  "openapi/category"),
                URLQueryItem(name :  "category_id", value : categoryId),
                URLQueryItem(name :  "page", value : page),
                URLQueryItem(name :  "option", value : option)
            ]
        case .search :
            return [URLQueryItem(name :  "route", value :  "openapi/search/autocomplete")]
        case .getFilters :
            return [URLQueryItem(name :  "route", value :  "openapi/category/filters")]
        case .ordersList :
            return [URLQueryItem(name :  "route", value :  "openapi/order")]
        case .orderInfo    :
            return [URLQueryItem(name :  "route", value :  "openapi/order/info")]
        case .accountInfo :
            return [URLQueryItem(name :  "route", value :  "openapi/account")]
        case .accountEdit :
            return [URLQueryItem(name :  "route", value :  "openapi/account/edit")]
        case .productDetail :
            return [URLQueryItem(name :  "route", value :  "openapi/product")]
        case .wishlistRemove :
            return [URLQueryItem(name :  "route", value :  "openapi/wishlist/remove")]
        case .wishlistAdd :
            return [URLQueryItem(name :  "route", value :  "openapi/wishlist/add")]
        case .wishlistList :
            return [URLQueryItem(name :  "route", value :  "openapi/wishlist/wishlist")]
        case .getPaymentAddresslist :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/getpaymentaddress")]
        case .addAddress :
            return [URLQueryItem(name :  "route", value :  "openapi/address/add")]
        case .shippingMethodList :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/getshippingmethods")]
        case .paymentAddress :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/getpaymentaddress")]
        case .countryList :
            return [URLQueryItem(name :  "route", value :  "openapi/address/getCountries")]
        case .stateList :
            return [URLQueryItem(name :  "route", value :  "openapi/address/getStates")]
        case .paymentMethod :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/getpaymentmethods")]
        case .addressFetchOnBasisOfID :
            return [URLQueryItem(name :  "route", value :  "openapi/address/getForm")]
        case .addressList :
            return [URLQueryItem(name :  "route", value :  "openapi/address/addresses")]
        case .dealOfThedayAPI(let categoryid) :
            return [
                URLQueryItem(name :  "route", value :  "openapi/home/dealproduct"),
                URLQueryItem(name :  "category_id", value : categoryid),
            ]            
        case .submitShippingmethod :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/submitshippingmethod")]
        case .submitPaymentMethodAndOrderOverview :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/submitpaymentmethod")]
        case .orderListAPI :
            return [URLQueryItem(name :  "route", value :  "openapi/order/orders")]
        case .addToCart :
            return [URLQueryItem(name :  "route", value :  "openapi/cart/add")]
        case .aboutUs :
            return [URLQueryItem(name :  "route", value :  "openapi/information/aboutus")]
        case .faq :
            return [URLQueryItem(name :  "route", value :  "openapi/information/faq")]
        case .logout :
            return [URLQueryItem(name :  "route", value :  "openapi/customer/logout")]
        case .cartList :
            return [URLQueryItem(name :  "route", value :  "openapi/cart/index")]
        case .editCartList :
            return [URLQueryItem(name :  "route", value :  "openapi/cart/edit")]
        case .getCartCount :
            return [URLQueryItem(name :  "route", value :  "openapi/cart/cartcount")]
        case .deleteCartList :
            return [URLQueryItem(name :  "route", value :  "openapi/cart/remove")]
        case .sortList :
            return [URLQueryItem(name :  "route", value :  "openapi/category/sortby")]
        case .sort(let search, let sortby, let order, let categoryId, let page) :
            return [
                URLQueryItem(name :  "route", value :  "openapi/search"),
                URLQueryItem(name :  "search", value : search),
                URLQueryItem(name :  "sortby", value : sortby),
                URLQueryItem(name :  "order", value : order),
                URLQueryItem(name :  "category_id", value : categoryId),
                URLQueryItem(name :  "page", value : page)
            ]
        case .checkoutSuccess :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/success")]
        case .confirmPayment :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/codconfirm")]
        case .applyFilter(let search, let option, let brand, let minprice,let  maxprice,let filterCategoryid,let page,let categoryId) :
            var optionString = ""
            for item in option {
                optionString += (optionString == "") ? item : ",\(item)"
            }
            var filterString = ""
            for item in filterCategoryid {
                filterString += (filterString == "") ? item : ",\(item)"
            }
            return [
                URLQueryItem(name :  "route", value :  "openapi/search"),
                URLQueryItem(name :  "search", value : search),
                URLQueryItem(name :  "option", value : optionString),
                URLQueryItem(name :  "brand", value : brand),
                URLQueryItem(name :  "minprice", value : minprice),
                URLQueryItem(name :  "maxprice", value : maxprice),
                URLQueryItem(name :  "filter_category_id", value : filterString),
                URLQueryItem(name :  "category_id", value : categoryId),
                URLQueryItem(name :  "page", value : page)
            ]
        case .stripeConfirm :
            return [URLQueryItem(name :  "route", value :  "openapi/checkout/stripeconfirm")]
        }
    }
    
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [
                APIParameterKey.email: email,
                APIParameterKey.password: password,
                APIParameterKey.fcmToken: APIParameterKey.token,
                APIParameterKey.deviceType: APIParameterKey.platform
            ]
        case .signup(let name, let email, let mobile, let password):
            return [
                APIParameterKey.firstName: name,
                APIParameterKey.email: email,
                APIParameterKey.telephone: mobile,
                APIParameterKey.password: password,
                APIParameterKey.confirm: password,
                APIParameterKey.fcmToken: APIParameterKey.token,
                APIParameterKey.deviceType: APIParameterKey.platform
            ]
        case .licenseUpload(let params):
            return params
        case .requestOTP(let email):
            return [
                APIParameterKey.email: email,
            ]
        case .resetPassword(let email, let otp, let password):
            return [
                APIParameterKey.email: email,
                APIParameterKey.otp: otp,
                APIParameterKey.password: password
            ]
        case .addToCart(let params):
            return params
        case .wishlistAdd(let params) :
            return params
        case .wishlistRemove(let params) :
            return params
        case .wishlistList(let params) :
            return params
        case .productDetail(let params) :
            return params
        case .accountInfo(let params) :
            return params
        case .logout(let params) :
            return params
        case .orderListAPI(let params) :
            return params
        case .cartList(let params) :
            return params
        case .editCartList(let params) :
            return params
        case .getCartCount(let params) :
            return params
        case .deleteCartList(let params) :
            return params
        case .search(let params) :
            return params
        case .getPaymentAddresslist(let params) :
            return params
        case .addAddress(let params) :
            return params
        case .addressFetchOnBasisOfID(let params) :
            return params
        case .stateList(let params) :
            return params
        case .shippingMethodList(let params) :
            return params
        case .submitShippingmethod(let params) :
            return params
        case .paymentMethod(let params) :
            return params
        case .submitPaymentMethodAndOrderOverview(let params) :
            return params
        case .getFilters(let params) :
            return params
        case .stripeConfirm(let params) :
            return params
        default:
            return nil
        }
    }
    
    
    struct APIParameterKey {
        
        static let firstName = "firstname"
        static let email = "email"
        static let telephone = "telephone"
        static let password = "password"
        static let confirm = "confirm"
        static let fcmToken = "fcm_token"
        static let deviceType = "device_type"
        static let customerId = "customer_id"
        static let otp = "otp"
        static let platform = "ios"
        static let token = "75b3be012c122bddcfc8bf3f150f591f"
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try ProductionServer.baseURL.asURL()
        var mURLComponent =  URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        mURLComponent?.queryItems = queryParams
        var urlRequest = URLRequest(url:(mURLComponent?.url)!)
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.form.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        }
        
        print(urlRequest.url)
        return urlRequest
    }
}
