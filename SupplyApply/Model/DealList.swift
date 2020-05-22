//
//  DealList.swift
//  SupplyApply
//
//  Created by Mac3 on 30/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - DealList
struct DealList: Codable {
    let success: Bool?
    let message: String?
    var products: [DealProduct]?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message, products
        case timeTaken = "time_taken"
    }
}

// MARK: - Product
struct DealProduct: Codable {
    let productID: String?
    let thumb: String?
    let name, stockStatus, modelNo: String?
    let options: [DealOption]?
    let optionsAvailable, wishlist: Bool?
    let price, minimum, special, countDown: String?
    var isButtonCaseClicked = false

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case thumb, name
        case stockStatus = "stock_status"
        case modelNo = "model_no."
        case options
        case optionsAvailable = "options_available"
        case wishlist, price, minimum, special
        case countDown = "count_down"
    }
}

// MARK: - Option
struct DealOption: Codable {
    let productOptionID: String?
    let productOptionValue: [DealProductOptionValue]?
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
struct DealProductOptionValue: Codable {
    let productOptionValueID, optionValueID, name, price: String?

    enum CodingKeys: String, CodingKey {
        case productOptionValueID = "product_option_value_id"
        case optionValueID = "option_value_id"
        case name, price
    }
}
