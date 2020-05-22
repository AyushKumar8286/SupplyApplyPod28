// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categories = try? newJSONDecoder().decode(Categories.self, from: jsonData)

import Foundation

// MARK: - Categories
struct Categories: Codable {
    let category: [Category]?

    enum CodingKeys: String, CodingKey {
        case category = "category"
    }
}

// MARK: - Category
struct Category: Codable {
    let categoryID: String?
    let name: String?
    let count: String?
    let thumb: String?
    let backgroundColor: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case name = "name"
        case count = "count"
        case thumb = "thumb"
        case backgroundColor = "background_color"
    }
}
