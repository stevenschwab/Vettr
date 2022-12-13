//
//  OpportunityRequest.swift
//  Vettr
//
//  Created by Steven Schwab on 11/14/22.
//

import Foundation

struct OpportunityRequest: Encodable {
    var opportunityName: String
    var opportunityType: String
    var opportunityUrl: String
    var userEmail: String
}
