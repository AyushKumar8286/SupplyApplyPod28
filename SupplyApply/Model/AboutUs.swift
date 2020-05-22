//
//  AboutUs.swift
//  SupplyApply
//
//  Created by Mac3 on 27/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AboutUs: Codable {
    let success: Bool?
    let message, welcomeDescription, storeTelephone, storeAddress: String?
    let storeEmail, storeFax, storeLat, storeLong: String?
    let facebookURL, instagramURL, whatsapp, messenger: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message
        case welcomeDescription = "description"
        case storeTelephone = "store_telephone"
        case storeAddress = "store_address"
        case storeEmail = "store_email"
        case storeFax = "store_fax"
        case storeLat = "store_lat"
        case storeLong = "store_long"
        case facebookURL = "facebook_url"
        case instagramURL = "instagram_url"
        case whatsapp, messenger
        case timeTaken = "time_taken"
    }
}

