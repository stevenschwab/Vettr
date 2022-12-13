//
//  RequestNewEventViewModel.swift
//  Vettr
//
//  Created by Steven Schwab on 11/14/22.
//

import Foundation
import Supabase

class RequestNewEventViewModel {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    func createOpportunityRequest(withName name: String, withOppType oppType: String, withURL url: String, withEmail email: String) async {
        
        let opportunityRequest = OpportunityRequest(
            opportunityName: name,
            opportunityType: oppType,
            opportunityUrl: url,
            userEmail: email
        )
        
        let query = client
            .database
            .from("Opportunity_Requests")
            .insert(values: opportunityRequest)
        
        do {
            try await query.execute()
        } catch {
            print("Error adding opportunity request, \(error.localizedDescription)")
        }
    }
    
}
