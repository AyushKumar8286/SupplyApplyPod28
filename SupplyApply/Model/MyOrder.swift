//
//  MyOrder.swift
//  SupplyApply
//
//  Created by Mac3 on 28/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - MyOrder
struct MyOrder: Codable {
    var orders: [Order]?
    let success: Bool?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case orders, success, message
        case timeTaken = "time_taken"
    }
}

// MARK: - Order
struct Order: Codable {
    let orderID, name, status, dateAdded: String?
    let products: Int?
    let total: String?
    var orderInfo: OrderInfo?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case name, status
        case dateAdded = "date_added"
        case products, total
        case orderInfo = "order_info"
    }
}

// MARK: - OrderInfo
struct OrderInfo: Codable {
    
    let orderID, invoiceNo, invoicePrefix, storeID: String?
    let storeName: String?
    let storeURL: String?
    let customerID, firstname, lastname, telephone: String?
    let email, paymentFirstname, paymentLastname, paymentCompany: String?
    let paymentAddress1, paymentAddress2, paymentPostcode, paymentCity: String?
    let paymentZoneID, paymentZone, paymentZoneCode, paymentCountryID: String?
    let paymentCountry, paymentISOCode2, paymentISOCode3, paymentAddressFormat: String?
    let paymentMethod, shippingFirstname, shippingLastname, shippingCompany: String?
    let shippingAddress1, shippingAddress2, shippingPostcode, shippingCity: String?
    let shippingZoneID, shippingZone, shippingZoneCode, shippingCountryID: String?
    let shippingCountry, shippingISOCode2, shippingISOCode3, shippingAddressFormat: String?
    let shippingMethod, comment, total, orderStatusID: String?
    let languageID, currencyID, currencyCode, currencyValue: String?
    let dateModified, dateAdded, ip, paymentAddress: String?
    let shippingAddress: String?
    var products: [Products]?
    let totals: [Total]?
    let histories: [History]?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case invoiceNo = "invoice_no"
        case invoicePrefix = "invoice_prefix"
        case storeID = "store_id"
        case storeName = "store_name"
        case storeURL = "store_url"
        case customerID = "customer_id"
        case firstname, lastname, telephone, email
        case paymentFirstname = "payment_firstname"
        case paymentLastname = "payment_lastname"
        case paymentCompany = "payment_company"
        case paymentAddress1 = "payment_address_1"
        case paymentAddress2 = "payment_address_2"
        case paymentPostcode = "payment_postcode"
        case paymentCity = "payment_city"
        case paymentZoneID = "payment_zone_id"
        case paymentZone = "payment_zone"
        case paymentZoneCode = "payment_zone_code"
        case paymentCountryID = "payment_country_id"
        case paymentCountry = "payment_country"
        case paymentISOCode2 = "payment_iso_code_2"
        case paymentISOCode3 = "payment_iso_code_3"
        case paymentAddressFormat = "payment_address_format"
        case paymentMethod = "payment_method"
        case shippingFirstname = "shipping_firstname"
        case shippingLastname = "shipping_lastname"
        case shippingCompany = "shipping_company"
        case shippingAddress1 = "shipping_address_1"
        case shippingAddress2 = "shipping_address_2"
        case shippingPostcode = "shipping_postcode"
        case shippingCity = "shipping_city"
        case shippingZoneID = "shipping_zone_id"
        case shippingZone = "shipping_zone"
        case shippingZoneCode = "shipping_zone_code"
        case shippingCountryID = "shipping_country_id"
        case shippingCountry = "shipping_country"
        case shippingISOCode2 = "shipping_iso_code_2"
        case shippingISOCode3 = "shipping_iso_code_3"
        case shippingAddressFormat = "shipping_address_format"
        case shippingMethod = "shipping_method"
        case comment, total
        case orderStatusID = "order_status_id"
        case languageID = "language_id"
        case currencyID = "currency_id"
        case currencyCode = "currency_code"
        case currencyValue = "currency_value"
        case dateModified = "date_modified"
        case dateAdded = "date_added"
        case ip
        case paymentAddress = "payment_address"
        case shippingAddress = "shipping_address"
        case products, totals, histories
    }
}

// MARK: - History
struct History: Codable {
    let dateAdded, status, comment: String?

    enum CodingKeys: String, CodingKey {
        case dateAdded = "date_added"
        case status, comment
    }
}

// MARK: - Product
struct Products: Codable {
    let name, model: String?
    let option: [Option]?
    let quantity, price, total, orderProductID: String?
    
    enum CodingKeys: String, CodingKey {
        case name, model, option, quantity, price, total
        case orderProductID = "order_product_id"
    }
}

// MARK: - Option
struct Option: Codable {
    let name, value: String?
}

// MARK: - Total
struct Total: Codable {
    let title, text: String?
}
