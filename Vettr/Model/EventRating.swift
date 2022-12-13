//
//  EventRating.swift
//  Vettr
//
//  Created by Steven Schwab on 12/8/22.
//

import Foundation

struct Event_Rating: Identifiable, Decodable {
    var id: Int
    var vettrScore: Int
    var overallValue: Double
    var pressCoverageRating: Double
    var salesValueRating: Double
    var timeCommitmentRating: Double
    var attendeePresenceRating: Double
    var overallRoiRating: Double
}
