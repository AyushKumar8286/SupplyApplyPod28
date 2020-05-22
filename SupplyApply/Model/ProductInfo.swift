//
//  ProductInfo.swift
//  SupplyApply
//
//  Created by Mac3 on 25/04/20.
//  Copyright © 2020 Suntec. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ProductInfo: Codable {
    let success: Bool?
    let data: DataClass?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success, data, message
        case timeTaken = "time_taken"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    
    let productID, name, quantity, minimum: String?
    let model, points, dateAdded, dateModified: String?
    let reviews: String?
    let rating: Int?
    let dataDescription, stock: String?
    let images: [Image]?
    let price: String?
    let special : Special?
    let tax: Bool?
    let options: Options?
    let optionsAvailable, configurable, onWishList: Bool?
    let bestSeller: [BestSeller]?
    let similarProducts : [SimilarProducts]?
    let recentViewed : [RecentViewed]?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case name, quantity, minimum, model, points
        case dateAdded = "date_added"
        case dateModified = "date_modified"
        case reviews, rating
        case dataDescription = "description"
        case stock, images, price, special, tax, options
        case optionsAvailable = "options_available"
        case configurable
        case onWishList = "on_wish_list"
        case recentViewed = "recent_viewed"
        case bestSeller = "best_seller"
        case similarProducts = "similar_products"
    }
}

// MARK: - BestSeller
struct BestSeller: Codable {
    let productID: String?
    let thumb: String?
    let name, price: String?
    let special : Special?
    let tax: Bool?
    let minimum: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case thumb, name, price, special, tax, minimum, rating
    }
}

// MARK: - BestSeller
struct SimilarProducts: Codable {
    let productID: String?
    let thumb: String?
    let name, price: String?
    let special: Special?
    let tax: Bool?
    let minimum: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case thumb, name, price, special, tax, minimum, rating
    }
}

// MARK: - BestSeller
struct RecentViewed: Codable {
    
    let productID: String?
    let thumb: String?
    let name, price: String?
    let special: Special?
    let tax: Bool?
    let minimum: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case thumb, name, price, special, tax, minimum, rating
    }
}

// MARK: - Image
struct Image: Codable {
    let popup, thumb: String?
}

// MARK: - Options
struct Options: Codable {
    let productOptionID: String?
    let productOptionValue: [ProductOptionValue]?
    let optionID, name, type, value: String?
    let optionsRequired: String?

    enum CodingKeys: String, CodingKey {
        case productOptionID = "product_option_id"
        case productOptionValue = "product_option_value"
        case optionID = "option_id"
        case name, type, value
        case optionsRequired = "required"
    }
}

// MARK: - ProductOptionValue
struct ProductOptionValue: Codable {
    let productOptionValueID, optionValueID, name: String?
    let image, bigImage: JSONNull?
    let price, pricePrefix: String?

    enum CodingKeys: String, CodingKey {
        case productOptionValueID = "product_option_value_id"
        case optionValueID = "option_value_id"
        case name, image
        case bigImage = "big-image"
        case price
        case pricePrefix = "price_prefix"
    }
}

enum Special: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Special.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Special"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
