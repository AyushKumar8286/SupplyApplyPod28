//
//  CountryList.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct CountryList: Codable {
    let success: Bool?
    let message: String?
    let countries: [Country]?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message, countries
        case timeTaken = "time_taken"
    }
}

// MARK: - Country
struct Country: Codable {
    let countryID, name, isoCode2, isoCode3: String?
    let addressFormat, postcodeRequired, status: String?

    enum CodingKeys: String, CodingKey {
        case countryID = "country_id"
        case name
        case isoCode2 = "iso_code_2"
        case isoCode3 = "iso_code_3"
        case addressFormat = "address_format"
        case postcodeRequired = "postcode_required"
        case status
    }
}
