// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SubCategories: Codable {
    
    let success: Bool?
    let message: String?
    let category: [Category]?
    let products: [Product]?
    let filterAvailable: Bool?
    let totalProduct: String?
    let totalPage: Int?
    let currentPage : String?
    let limit: JSONAny?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message, category, products
        case filterAvailable = "filter_available"
        case totalProduct = "total_product"
        case totalPage = "total_page"
        case currentPage = "current_page"
        case limit = "limit"
        case timeTaken = "time_taken"
    }
}

// MARK: - Product
struct Product: Codable {
    let productID: String?
    let thumb, origImage: String?
    let name: String?
    let stockStatus: String?
    let modelNo: String?
    let options: [ProductOption]?
    let optionsAvailable, wishlist: Bool?
    let price, minimum: String?
    var isButtonCaseClicked = false
    var isWishList = false

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case thumb
        case origImage = "orig_image"
        case name
        case stockStatus = "stock_status"
        case modelNo = "model_no."
        case options
        case optionsAvailable = "options_available"
        case wishlist, price, minimum
    }
}

// MARK: - Option
struct ProductOption: Codable {
    let productOptionID: String?
    let productOptionValue: [ProductOptionData]?
    let optionID, name, type, value: String?
    let optionRequired: String?

    enum CodingKeys: String, CodingKey {
        case productOptionID = "product_option_id"
        case productOptionValue = "product_option_value"
        case optionID = "option_id"
        case name, type, value
        case optionRequired = "required"
    }
}

// MARK: - ProductOptionValue
struct ProductOptionData: Codable {
    let productOptionValueID, optionValueID, name, price: String?

    enum CodingKeys: String, CodingKey {
        case productOptionValueID = "product_option_value_id"
        case optionValueID = "option_value_id"
        case name, price
    }
}
