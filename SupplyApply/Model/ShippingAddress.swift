//
//  ShippingAddress.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ShippingAddress: Codable {
    let success: Bool?
    let shippingAddress : [ShippingAddressList]?
    let paymentAddress: [PaymentAddressList]?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success
        case shippingAddress = "shipping_address"
        case paymentAddress = "payment_address"
        case message
        case timeTaken = "time_taken"
    }
}

// MARK: - ShippingAddress
struct ShippingAddressList: Codable {
    let addressID, firstname, lastname, company: String?
    let emailID, city, postcode, phone: String?
    let address1, address2, address, zoneID: String?
    let zone, country, addressFormat, countryID: String?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case firstname, lastname, company
        case emailID = "email_id"
        case city, postcode, phone
        case address1 = "address_1"
        case address2 = "address_2"
        case address
        case zoneID = "zone_id"
        case zone, country
        case addressFormat = "address_format"
        case countryID = "country_id"
    }
}

// MARK: - PaymentAddress
struct PaymentAddressList: Codable {
    let addressID, firstname, lastname, company: String?
    let emailID, city, postcode, phone: String?
    let address1, address2, address, zoneID: String?
    let zone, country, addressFormat, countryID: String?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case firstname, lastname, company
        case emailID = "email_id"
        case city, postcode, phone
        case address1 = "address_1"
        case address2 = "address_2"
        case address
        case zoneID = "zone_id"
        case zone, country
        case addressFormat = "address_format"
        case countryID = "country_id"
    }
}
