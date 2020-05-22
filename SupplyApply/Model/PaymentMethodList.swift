//
//  PaymentMethodList.swift
//  SupplyApply
//
//  Created by Mac3 on 07/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct PaymentMethodList: Codable {
    let success: Bool?
    let paymentMethods: [PaymentMethod]?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success
        case paymentMethods = "payment_methods"
        case message
        case timeTaken = "time_taken"
    }
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let code, title, terms, sortOrder: String?
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case code, title, terms
        case sortOrder = "sort_order"
    }
}
