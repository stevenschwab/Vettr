//
//  SceneDelegate.swift
//  Vettr
//
//  Created by Steven Schwab on 10/29/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Method called when the app first launches
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Setting profile screen if user is logged in
        let tabBarController = window!.rootViewController as! UITabBarController
        if let tempViewControllers = tabBarController.viewControllers {
            
            if let profileNavController = tempViewControllers[3] as? UINavigationController {
                //Profile nav controller is not nil
                if UserDefaults.standard.object(forKey: "currentUserId") != nil {
                    let profileStoryboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                    let loggedInProfileViewController = profileStoryboard.instantiateViewController(withIdentifier: "LoggedInProfileViewController") as! LoggedInProfileVC
                    // Add logged in profile screen to nav stack
                    profileNavController.pushViewController(loggedInProfileViewController, animated: false)
                }
            }
        }
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = K.BrandColors.vettrBlue
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }

}

