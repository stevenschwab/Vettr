//
//  eventDetailViewModel.swift
//  Vettr
//
//  Created by Steven Schwab on 11/18/22.
//

import Foundation
import Supabase

class EventDetailViewModel {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)

    var media = [Media]()
    var eventSpeakers = [EventSpeakers]()

    func fetchMediaForEvent(with eventID: UUID) async {
        let query = client
            .database
            .from("Event_Media")
            .select(columns: "event_id, Media_Types (id, name, logo)")
            .eq(column: "event_id", value: "\(eventID)")

        do {
            let response = try await query.execute()

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let media = try response.decoded(to: [Media].self, using: decoder)

                DispatchQueue.main.async {
                    self.media = media
                }
                
            } catch {
                print("There was an error decoding media for event, \(error.localizedDescription)")
            }
        } catch {
            print("There was an error fetching media for event, \(error.localizedDescription)")
        }

    }
    
    func fetchSpeakersForEvent(eventID: UUID) async {
        let query = client
            .database
            .from("event_speakers_view")
            .select(columns: "speakers")
            .eq(column: "event_id", value: "\(eventID)")

        do {
            let response = try await query.execute()

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let eventSpeakers = try response.decoded(to: [EventSpeakers].self, using: decoder)

                DispatchQueue.main.async {
                    self.eventSpeakers = eventSpeakers
                }
                
            } catch {
                print("There was an error decoding media for event, \(error.localizedDescription)")
            }
        } catch {
            print("There was an error fetching media for event, \(error.localizedDescription)")
        }
    }
    
    func numberOfSpeakers() -> Int {
        eventSpeakers.count
    }

    func numberOfMediaItems() -> Int {
        media.count
    }
    
    func checkReviewCount(eventId: UUID, userId: UUID) async -> Int {
        
        var reviewCount = 0
        
        let query = client
            .database
            .from("Reviews")
            .select(columns: "*", count: .exact)
            .eq(column: "event_id", value: "\(eventId)")
            .eq(column: "user_id", value: "\(userId)")
        
        do {
            let response = try await query.execute()
            
            if let safeCount = response.count {
                reviewCount = safeCount
            }
            
        } catch {
            print("There was an error fetching the number of reviews for an event, \(error.localizedDescription)")
        }
        
        return reviewCount
    }
    
}

