//
//  SearchDataViewModel.swift
//  Vettr
//
//  Created by Steven Schwab on 11/2/22.
//

import UIKit
import Supabase

class SearchDataViewModel {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    var eventsFromSearch = [Event]()
    var numberOfEventsFromSearch = 0
    var totalEventCount: Int = 0

    func fetch(with searchText: String) async {

        let query = client
            .database
            .from("Events")
            .select(columns: "*, Opportunity_Types!inner(*), Categories!inner(*), Event_Ratings!inner(*), Top_Two_Event_Ratings!inner(*)")
            .ilike(column: "title", value: "%\(searchText)%")

        do {
            let response = try await query.execute()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let events = try response.decoded(to: [Event].self, using: decoder)

                DispatchQueue.main.async {
                    self.eventsFromSearch = events
                    self.numberOfSearchItems()
                }
                
            } catch {
                print("There was an error decoding the search events query, \(error.localizedDescription)")
            }
        } catch {
            print("There was an error fetching search events, \(error.localizedDescription)")
        }

    }

    func numberOfSearchItems() {
        numberOfEventsFromSearch = eventsFromSearch.count
    }
    
    func numberOfEventsInDatabase() async {
        
        let query = client
            .database
            .from("Events")
            .select(columns: "id", count: .exact)
        
        do {
            let response = try await query.execute()
            
            if let safeCount = response.count {
                
                DispatchQueue.main.async {
                    self.totalEventCount = safeCount
                }
            }
        } catch {
            print("There was an error fetching the number of events, \(error.localizedDescription)")
        }
    }

    func searchItem(at index: Int) -> Event {
        eventsFromSearch[index]
    }
    
    func setCountLabel() -> String {
        "\(String(describing: eventsFromSearch.count)) out of \(String(describing: totalEventCount)) opportunities"
    }
}
