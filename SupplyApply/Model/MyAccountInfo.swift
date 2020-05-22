//
//  MyAccountInfo.swift
//  SupplyApply
//
//  Created by Mac3 on 28/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MyAccountInfo: Codable {
    
    let success: Bool?
    let accountInfo: AccountInfo?
    let preferences: Preferences?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success
        case accountInfo = "account_info"
        case preferences, message
        case timeTaken = "time_taken"
    }
}

// MARK: - AccountInfo
struct AccountInfo: Codable {
    let name: String?
    let address: Address?
    let email, phone, password: String?
    let license: String?
}

// MARK: - Address
struct Address: Codable {
    let addressID, name, address: String?

    enum CodingKeys: String, CodingKey {
        case addressID = "address_id"
        case name, address
    }
}

// MARK: - Preferences
struct Preferences: Codable {
    let notification, newsletter: Bool?
}
