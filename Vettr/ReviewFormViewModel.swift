//
//  ReviewFormViewModel.swift
//  Vettr
//
//  Created by Steven Schwab on 11/14/22.
//

import Foundation
import Supabase

class ReviewFormViewModel {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    func createReviewForEvent (
        withPressCoverageRating press_coverage_rating: Double,
        withSalesValueRating sales_value_rating: Double,
        withTimeCommitmentRating time_commitment_rating: Double,
        withAttendeePresenceRating attendee_presence_rating: Double,
        withOverallROIRating overrall_roi_rating: Double,
        isSponsorshipRequired sponsorship_required: Bool,
        withPressAttendance press_attendance: Bool,
        areSpeakerProposalsRequired speaker_proposals_accepted: Bool,
        withCustomerReview customer_review: String?,
        withEventID event_id: UUID,
        withUserWhoSubmittedReview user_id: UUID
    ) async -> String {
        
        let review = ReviewItem(
            eventId: event_id,
            userId: user_id,
            pressCoverageRating: press_coverage_rating,
            salesValueRating: sales_value_rating,
            timeCommitmentRating: time_commitment_rating,
            attendeePresenceRating: attendee_presence_rating,
            overrallRoiRating: overrall_roi_rating,
            sponsorshipRequired: sponsorship_required,
            pressAttendance: press_attendance,
            speakerProposalsAccepted: speaker_proposals_accepted,
            customerReview: customer_review
        )
        
        let query = client
            .database
            .from("Reviews")
            .insert(values: review)
        
        do {
            try await query.execute()
            return "success"
        } catch {
            print("Error inserting review for event, \(error.localizedDescription)")
            return "error"
        }
    }
}

