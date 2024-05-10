//
//  Constants.swift
//  Vettr
//
//  Created by Steven Schwab on 10/30/22.
//
import Foundation
import UIKit

struct K {

    struct BrandColors {
        static let vettrBlue = hexStringToUIColor("#1A3E52")
    }
    
    struct Supabase {
        private static let config = Bundle.main.path(forResource: "SupabaseConfig", ofType: "plist").flatMap { NSDictionary(contentsOfFile: $0) }
        
        static let projectAPIkey = config?["PROJECT_API_KEY"] as? String ?? ""
        static let projectURL = URL(string: config?["PROJECT_URL"] as? String ?? "")!
    }
}
