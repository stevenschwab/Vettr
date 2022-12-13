//
//  Event.swift
//  Vettr
//
//  Created by Steven Schwab on 11/10/22.
//

import Foundation

struct Event: Identifiable, Decodable {
    var id: UUID
    var title: String
    var description: String
    var attendeesAmount: Int?
    var acceptsSpeakerSubmissions: Bool
    var flexibleSpeakerFormats: Bool
    var liveAudienceQAndA: Bool
    var liveStreamedSessions: Bool
    var openToPress: Bool
    var payToPlay: Bool
    var slideDeckRequired: Bool
    var categoryId: Int
    var opportunityTypeId: Int
    var OpportunityTypes: Opportunity_Type
    var Categories: Category
    var EventRatings: [Event_Rating]
    var TopTwoEventRatings: [Top_Event_Ratings]
    var eventViewCount: Int
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        // Two events are the same if they have the same UUID
        return lhs.id == rhs.id
    }
}
