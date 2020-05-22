//
//  StateList.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct StateList: Codable {
    let success: Bool?
    let message: String?
    let states: [State]?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message, states
        case timeTaken = "time_taken"
    }
}

// MARK: - State
struct State: Codable {
    let zoneID, countryID, name, code: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case zoneID = "zone_id"
        case countryID = "country_id"
        case name, code, status
    }
}
