//
//  SupabaseAuthManager.swift
//  Vettr
//
//  Created by Steven Schwab on 11/7/22.
//

import UIKit
import Supabase

class SupabaseAuthManager {
    
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
    
    //MARK: - Sign up
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) async {
        
        do {
            try await client.auth.signUp(email: email, password: password)
            completionBlock(true)
        } catch {
            print("Error creating user, \(error.localizedDescription)")
            completionBlock(false)
        }
            
    }
    
    //MARK: - Log in
    
    func signInWithEmailAndPassword(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) async {
        
        do {
            try await client.auth.signIn(email: email, password: password)
            if let userId = client.auth.session?.user.id {
                // Convert the user's ID to a String
                let userIdString = userId.uuidString
                // Save the user's ID to UserDefaults
                UserDefaults.standard.set(userIdString, forKey: "currentUserId")
                if let expiresIn = client.auth.session?.expiresIn {
                    let currentTime = Date()
                    let secondsToAdd: TimeInterval = expiresIn
                    let expiresAt = currentTime.addingTimeInterval(secondsToAdd)
                    UserDefaults.standard.set(expiresAt, forKey: "jwtExpiration")
                }
            }
            completionBlock(true)
        } catch {
            print("Error signing in user, \(error.localizedDescription)")
            completionBlock(false)
        }
        
    }
    
    //MARK: - Log out
    
    func logOut() async {
        
        do {
            try await client.auth.signOut()
            // Remove the user's ID from UserDefaults
            UserDefaults.standard.removeObject(forKey: "currentUserId")
            UserDefaults.standard.removeObject(forKey: "jwtExpiration")
        } catch {
            print("Error signing out user: %@", error.localizedDescription)
        }
    }
    
}
