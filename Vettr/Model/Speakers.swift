//
//  Speakers.swift
//  Vettr
//
//  Created by Steven Schwab on 11/10/22.
//

import Foundation

struct Speakers: Identifiable, Decodable {
    var id: Int
    var eventId: UUID
    var name: String
    var title: String
    var companyName: String
}
