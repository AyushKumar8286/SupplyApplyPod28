//
//  FilterList.swift
//  SupplyApply
//
//  Created by Mac3 on 06/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - FilterList
struct FilterList: Codable {
    let success: Bool?
    let message: String?
    let filterData: [FilterDatum]?
    let products: [FilterProduct]?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message
        case filterData = "filter_data"
        case products
        case timeTaken = "time_taken"
    }
}

// MARK: - FilterDatum
struct FilterDatum: Codable {
    let color, packetSize: [FilterColor]?
    let price: Price?
    let brand: [Brand]?

    enum CodingKeys: String, CodingKey {
        case color = "Color"
        case packetSize = "Packet Size"
        case price, brand
    }
}

// MARK: - Brand
struct Brand: Codable {
    let name: String?
}

// MARK: - Color
struct FilterColor: Codable {
    let optionValueID, name, sortOrder, isColor: String?
    let hexCode: String?

    enum CodingKeys: String, CodingKey {
        case optionValueID = "option_value_id"
        case name
        case sortOrder = "sort_order"
        case isColor = "is_color"
        case hexCode = "hex_code"
    }
}

// MARK: - Price
struct Price: Codable {
    let minprice, maxprice: String?
}

// MARK: - Product
struct FilterProduct: Codable {
    let productID: String?
    let image: String?
    let name, model, price: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case image, name, model, price
    }
}
