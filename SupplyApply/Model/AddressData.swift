

//
//  AddressData.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AddressData: Codable {
    let success: Bool?
    let data: [AddressIdData]?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, data, message
        case timeTaken = "time_taken"
    }
}

// MARK: - Datum
struct AddressIdData: Codable {
    let firstname, lastname, company, address1: String?
    let address2, postcode, city, countryID: String?
    let countryName, zoneID, stateName: String?
    let customFields: [JSONAny]?
    let addressCustomField: JSONNull?
    let datumDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case firstname, lastname, company
        case address1 = "address_1"
        case address2 = "address_2"
        case postcode, city
        case countryID = "country_id"
        case countryName = "country_name"
        case zoneID = "zone_id"
        case stateName = "state_name"
        case customFields = "custom_fields"
        case addressCustomField = "address_custom_field"
        case datumDefault = "default"
    }
}
