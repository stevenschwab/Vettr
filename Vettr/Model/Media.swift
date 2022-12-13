//
//  Media.swift
//  Vettr
//
//  Created by Steven Schwab on 11/18/22.
//

import Foundation

struct Media: Decodable {
    var eventId: UUID
    var MediaTypes: Media_Types
}
