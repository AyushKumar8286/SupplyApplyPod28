//
//  SortList.swift
//  SupplyApply
//
//  Created by Mac3 on 01/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - SortList
struct SortList: Codable {
    let success: Bool?
    let message: String?
    let sorts: [Sort]?
    let timeTaken: Double?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case success, message, sorts
        case timeTaken = "time_taken"
    }
}

// MARK: - Sort
struct Sort: Codable {
    let text, value: String?
}
