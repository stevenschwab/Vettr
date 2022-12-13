//
//  ProfileViewModel.swift
//  Vettr
//
//  Created by Steven Schwab on 11/15/22.
//

import Foundation
import Supabase

class ProfileViewModel {
    lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)

    var userLoggedInId: UUID?
    var userProfile: UserProfile?

    func fetchUserProfileData() async throws {
        let query = client
            .database
            .from("User_Profiles")
            .select()
            .eq(column: "id", value: "\(userLoggedInId!)")

        do {
            let response = try await query.execute()

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let user_profile = try response.decoded(to: UserProfile.self, using: decoder)

                DispatchQueue.main.async {
                    self.userProfile = user_profile
                }

            } catch {
                print("There was an error decoding user profile data, \(error.localizedDescription)")
            }
        } catch {
            print("There was an error fetching user profile data, \(error.localizedDescription)")
        }

    }
    
//    func uploadProfileAvatar(with file: File) async throws {
//        let query = client
//            .storage
//            .from("profiles")
//            .upload(path: "public/profiles/\(userLoggedInId)", file: file, fileOptions: FileOptions?)
//    }
    
}
