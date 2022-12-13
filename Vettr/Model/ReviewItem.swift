//
//  ReviewItem.swift
//  Vettr
//
//  Created by Steven Schwab on 11/7/22.
//

import UIKit

struct ReviewItem: Encodable {
    var eventId: UUID
    var userId: UUID
    var pressCoverageRating: Double
    var salesValueRating: Double
    var timeCommitmentRating: Double
    var attendeePresenceRating: Double
    var overrallRoiRating: Double
    var sponsorshipRequired: Bool
    var pressAttendance: Bool
    var speakerProposalsAccepted: Bool
    var customerReview: String?
}
