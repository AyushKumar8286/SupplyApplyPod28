//
//  ShippingList.swift
//  SupplyApply
//
//  Created by Mac3 on 07/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ShippingList: Codable {
    let success: Bool?
    let shippingMethods: [ShippingMethod]?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success
        case shippingMethods = "shipping_methods"
        case message
        case timeTaken = "time_taken"
    }
}

// MARK: - ShippingMethod
struct ShippingMethod: Codable {
    let title: String?
    let quote: Quote?
    let sortOrder: String?
    let error: Bool?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case title, quote
        case sortOrder = "sort_order"
        case error
    }
}

// MARK: - Quote
struct Quote: Codable {
    let flat: Flat?
}

// MARK: - Flat
struct Flat: Codable {
    let code, title, cost, taxClassID: String?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case code, title, cost
        case taxClassID = "tax_class_id"
        case text
    }
}
