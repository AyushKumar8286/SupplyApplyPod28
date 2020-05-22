//
//  SubmitPaymentMethod.swift
//  SupplyApply
//
//  Created by Mac3 on 07/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - SubmitPaymentMethod
struct SubmitPaymentMethod: Codable {
    let success: Bool?
    let data: PaymentDataClass?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, data, message
        case timeTaken = "time_taken"
    }
}

// MARK: - DataClass
struct PaymentDataClass: Codable {
    let products: [DataProduct]?
    let totals: [PaymentTotal]?
    let completeTotal: Double?
    let payment: Payment?
    let paymentMethod: String?

    enum CodingKeys: String, CodingKey {
        case products, totals
        case completeTotal = "complete_total"
        case payment
        case paymentMethod = "payment_method"
    }
}

// MARK: - Payment
struct Payment: Codable {
    let textTestmode, buttonConfirm, testmode: String?
    let action: String?
    let business, itemName: String?
    let products: [PaymentProduct]?
    let discountAmountCart: Int?
    let currencyCode, firstName, lastName, address1: String?
    let address2, city, zip, country: String?
    let email: String?
    let rm, noNote, noShipping: Int?
    let charset, bn, invoice, lc: String?
    let paymentReturn, notifyURL, cancelReturn: String?
    let paymentaction: String?
    let orderID, custom: Int?
    let webview: Bool?

    enum CodingKeys: String, CodingKey {
        case textTestmode = "text_testmode"
        case buttonConfirm = "button_confirm"
        case testmode, action, business
        case itemName = "item_name"
        case products
        case discountAmountCart = "discount_amount_cart"
        case currencyCode = "currency_code"
        case firstName = "first_name"
        case lastName = "last_name"
        case address1, address2, city, zip, country, email, rm
        case noNote = "no_note"
        case noShipping = "no_shipping"
        case charset, bn, invoice, lc
        case paymentReturn = "return"
        case notifyURL = "notify_url"
        case cancelReturn = "cancel_return"
        case paymentaction
        case orderID = "order_id"
        case custom, webview
    }
}

// MARK: - PaymentProduct
struct PaymentProduct: Codable {
    let name, model: String?
    let price: Double?
    let quantity: Quantity?
    let option: [JSONAny]?
    let weight: Double?
}

enum Quantity: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Quantity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Quantity"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - DataProduct
struct DataProduct: Codable {
    let cartID, productID, name, model: String?
    let option: [JSONAny]?
    let recurring, quantity, subtract, price: String?
    let total: String?
    let href: String?

    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case productID = "product_id"
        case name, model, option, recurring, quantity, subtract, price, total, href
    }
}

// MARK: - Total
struct PaymentTotal: Codable {
    let title, text: String?
}

