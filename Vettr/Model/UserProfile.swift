//
//  UserProfile.swift
//  Vettr
//
//  Created by Steven Schwab on 11/17/22.
//

import Foundation

struct UserProfile: Identifiable, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var username: String
    var userImage: String
    var createdAt: Date
    var updatedAt: Date
}
