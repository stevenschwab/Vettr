//
//  LoggedInProfileViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 10/30/22.
//

import UIKit
import GoogleSignIn

class LoggedInProfileVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userFirstAndLastNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    
    //MARK: - Properties
    
    let supabaseAuthManager = SupabaseAuthManager()
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

private extension LoggedInProfileVC {
    func initialize() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.BrandColors.vettrBlue]
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {

        Task {
            
            await supabaseAuthManager.logOut()
            
            DispatchQueue.main.async {
                self.showLoggedOutProfileView()
            }
        }
    }
    
    func showLoggedOutProfileView() {
        let firstViewController = self.navigationController?.viewControllers.first
        self.navigationController?.popToViewController(firstViewController!, animated: true)
    }
}
