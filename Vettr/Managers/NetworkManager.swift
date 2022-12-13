//
//  NetworkManager.swift
//  Vettr
//
//  Created by Steven Schwab on 12/11/22.
//

import UIKit
import Supabase

class NetworkManager {
    static let shared = NetworkManager()
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    //MARK: - Fetch Events By Category And Filter
    
    func fetchEventsBy(category: String = "All", filter: String = "All", range: Int, completed: @escaping (Result<[Event], VRError>) -> Void) async {

        let selectColumns: String = "*, Opportunity_Types!inner(*), Categories!inner(*), Event_Ratings!inner(*), Top_Two_Event_Ratings!inner(*)"
        var orderColumn: String?
        var isAscending: Bool?
        
        switch filter {
        case "A to Z":
            orderColumn = "title"
            isAscending = true
        case "Highest Rated":
            orderColumn = "Event_Ratings.vettr_score"
            isAscending = false
        case "Recently Trending":
            orderColumn = "event_view_count"
            isAscending = false
        default:
            orderColumn = nil
            isAscending = nil
        }
        
        var queryPostgrestFilterBuilder = client
            .database
            .from("Events")
            .select(columns: "\(selectColumns)")
            .range(from: 0, to: range)
        
        var queryPostgrestTransformBuilder = client
            .database
            .from("Events")
            .select(columns: "\(selectColumns)")
            .order(column: "\(orderColumn ?? "title")", ascending: isAscending ?? true)
        
        if category != "All" && category != "Others" && filter == "All" {
            queryPostgrestFilterBuilder = client
                .database
                .from("Events")
                .select(columns: "\(selectColumns)")
                .equals(column: "Categories.name", value: "\(category)")
        } else if category != "All" && category != "Others" && filter != "All" {
            queryPostgrestTransformBuilder = client
                .database
                .from("Events")
                .select(columns: "\(selectColumns)")
                .equals(column: "Categories.name", value: "\(category)")
                .order(column: "\(orderColumn!)", ascending: isAscending!)
        } else if category == "Others" && filter == "All" {
            queryPostgrestFilterBuilder = client
                .database
                .from("Events")
                .select(columns: "\(selectColumns)")
                .not(column: "Categories.id", operator: .in, value: "(1, 2, 3)")
        } else if category == "Others" && filter != "All" {
            queryPostgrestTransformBuilder = client
                .database
                .from("Events")
                .select(columns: "\(selectColumns)")
                .not(column: "Categories.id", operator: .in, value: "(1, 2, 3)")
                .order(column: "\(orderColumn!)", ascending: isAscending!)
        }
        
        if orderColumn != nil {

            let query = queryPostgrestTransformBuilder

            do {
                
                let response = try await query.execute()
                
                if response.status != 200 {
                    completed(.failure(.invalidResponse))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let events = try decoder.decode([Event].self, from: response.data)
                    completed(.success(events))
                } catch {
                    completed(.failure(.invalidData))
                }
            } catch {
                completed(.failure(.unableToComplete))
            }
        } else {

            let query = queryPostgrestFilterBuilder

            do {
                
                let response = try await query.execute()
                
                if response.status != 200 {
                    completed(.failure(.invalidResponse))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let events = try decoder.decode([Event].self, from: response.data)
                    completed(.success(events))
                } catch {
                    completed(.failure(.invalidData))
                }
            } catch {
                completed(.failure(.unableToComplete))
            }
        }

    }

    
}
