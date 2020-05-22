// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
struct StringResponse: Codable {
    let success: Bool?
    let data: String?
    let message: String?
    let timeTaken: Double?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
        case timeTaken = "time_taken"
    }
}
