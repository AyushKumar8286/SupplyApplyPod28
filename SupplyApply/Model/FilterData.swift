//
//  FilterData.swift
//  SupplyApply
//
//  Created by Mac3 on 11/05/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct FilterData: Codable {
    let success: Bool?
    let message: String?
    var filterData: [Filterdata]?
    let categoryFilter: Bool?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, message
        case filterData = "filter_data"
        case categoryFilter = "category_filter"
        case timeTaken = "time_taken"
    }
}

// MARK: - FilterDatum
struct Filterdata: Codable {
    
    var color, packetSize: [Color]?
    let price: Filterprice?
    let brand: [Filterbrand]?
    var categories: [Filtercategory]?

    enum CodingKeys: String, CodingKey {
        case color = "Color"
        case packetSize = "Packet Size"
        case price, brand, categories
    }
}

// MARK: - Brand
struct Filterbrand: Codable {
    let name: String?
}

// MARK: - Category
struct Filtercategory: Codable {
    let categoryID, name, count: String?
    let thumb: String?
    let backgroundColor: String?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case name, count, thumb
        case backgroundColor = "background_color"
    }
}

// MARK: - Color
struct Color: Codable {
    let optionValueID, name, sortOrder, isColor: String?
    let hexCode: String?
    var isSelected = false

    enum CodingKeys: String, CodingKey {
        case optionValueID = "option_value_id"
        case name
        case sortOrder = "sort_order"
        case isColor = "is_color"
        case hexCode = "hex_code"
    }
}

// MARK: - Price
struct Filterprice: Codable {
    let minprice, maxprice, currencyTitle: String?

    enum CodingKeys: String, CodingKey {
        case minprice, maxprice
        case currencyTitle = "currency_title"
    }
}

