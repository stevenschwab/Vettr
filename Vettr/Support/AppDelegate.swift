//
//  AppDelegate.swift
//  Vettr
//
//  Created by Steven Schwab on 10/29/22.
//

import UIKit
import Supabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // Called when app first launches - Gets called before viewDidLoad
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        fetchUser()
        
        return true
    }
    
    // Triggered when something happens while app is open (user receives a phone call)
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    // When app disappears off screen
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    // This method is called every time the app becomes active, so it would be a good place to check for a valid JWT and refresh it if necessary.
    func applicationDidBecomeActive(_ application: UIApplication) {
        fetchUser()
    }
    
    // App is terminated (phone terminates app or user terminates app)
    func applicationWillTerminate(_ application: UIApplication) {
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func fetchUser() {
        lazy var client = SupabaseClient(supabaseURL: K.Supabase.projectURL, supabaseKey: K.Supabase.projectAPIkey)
        // Check if the user is logged in
        if let userId = client.auth.session?.user.id {
            print("The user is logged in")
            // Check if the JWT has expired
            if let jwtExpirationDate = UserDefaults.standard.object(forKey: "jwtExpiration") as? Date {
                let currentTime = Date()
                if currentTime > jwtExpirationDate {
                    print("The JWT has expired")
                    let supabaseAuthManager = SupabaseAuthManager()
                    Task {
                        await supabaseAuthManager.logOut()
                    }
                    
                } else {
                    print("JWT not expired")
                }
            }
            
            // Check if user id exists in user defaults
            if UserDefaults.standard.object(forKey: "currentUserId") == nil {
                // Convert the user's ID to a String
                let userIdString = userId.uuidString
                // Save the user's ID to UserDefaults
                UserDefaults.standard.set(userIdString, forKey: "currentUserId")
            }
        } else {
            print("The user is not logged in")
            // The user is not logged in
            if UserDefaults.standard.object(forKey: "currentUserId") != nil {
                // The currentUserId key exists in UserDefaults
                UserDefaults.standard.removeObject(forKey: "currentUserId")
            } else {
                // The currentUserId key does not exist in UserDefaults, so you can redirect
                return
            }
        }
    }

    // MARK: - Core Data stack
    // Called lazy because it only gets loaded with data when you try and use it (only occupying memory when you use it)
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "Vettr")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}
