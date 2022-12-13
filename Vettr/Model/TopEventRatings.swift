//
//  TopEventRatings.swift
//  Vettr
//
//  Created by Steven Schwab on 12/8/22.
//

import Foundation

struct Top_Event_Ratings: Decodable {
    var eventId: UUID
    var ratings: [Top_Two_Ratings]
}
