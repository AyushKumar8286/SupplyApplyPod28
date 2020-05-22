// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addProductToProjectRequest = try? newJSONDecoder().decode(AddProductToProjectRequest.self, from: jsonData)

import Foundation

// MARK: - AddProductToProjectRequest
struct User: Codable {
    let success: Bool?
    let data: UserData?
    let customerID: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let telephone: String?
    let fax: String?
    let newsletter: String?
    let customerGroupID: String?
    let addressID: String?
    let message: String?
    let licenseUpload: Bool?
    let licenseVerify: Bool?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case telephone = "telephone"
        case fax = "fax"
        case newsletter = "newsletter"
        case customerGroupID = "customer_group_id"
        case addressID = "address_id"
        case message = "message"
        case licenseUpload = "license_upload"
        case licenseVerify = "license_verify"
        case timeTaken = "time_taken"
    }
}

// MARK: - DataClass
struct UserData: Codable {
    let cookieID: String?
    let customer: CustomerData?
    let customerID: String?
    let appToken: String?
    let count: Int?

    enum CodingKeys: String, CodingKey {
        case cookieID = "cookie_id"
        case customer = "customer"
        case customerID = "customer_id"
        case appToken = "app_token"
        case count = "count"
    }
}

// MARK: - Customer
struct CustomerData: Codable {
    let customerID: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let telephone: String?
    let fax: String?
    let newsletter: String?
    let customerGroupID: String?
    let addressID: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case telephone = "telephone"
        case fax = "fax"
        case newsletter = "newsletter"
        case customerGroupID = "customer_group_id"
        case addressID = "address_id"
    }
}
