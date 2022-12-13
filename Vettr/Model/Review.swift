//
//  Review.swift
//  Vettr
//
//  Created by Steven Schwab on 11/11/22.
//

import Foundation

struct Review: Identifiable, Codable {
    var id: UUID
    var userId: UUID
    var eventId: UUID
    var pressCoverageRating: Double
    var salesValueRating: Double
    var timeCommitmentRating: Double
    var attendeePresenceRating: Double
    var overrallRoiRating: Double
    var sponsorshipRequired: Bool
    var pressAttendance: Bool
    var speakerProposalsRequired: Bool
    var title: String?
    var customerReview: String?
    var createdAt: Date
    var updatedAt: Date
}
