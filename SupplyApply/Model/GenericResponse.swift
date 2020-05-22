// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
struct GenericResponse: Codable {
    
    let success: Bool?
    let message: String?
    let timeTaken: Double?
    let descrip : String?
    let count : Int?
    let trackTest : String?
    let trackLink : String?
    let action : String?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case timeTaken = "time_taken"
        case descrip = "description"
        case count = "count"
        case trackTest = "track_text"
        case trackLink = "tracking_link"
        case action = "action"
    }
}
