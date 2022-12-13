//
//  LoggedOutProfileViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/1/22.
//

import UIKit
import GoogleSignIn

class LoggedOutProfileVC: UIViewController {
    
    @IBOutlet var googleSignInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
}

private extension LoggedOutProfileVC {
    func initialize() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        googleSignInButton.style = .wide
    }
    
    @IBAction func googleSignInButtonTapped(_ sender: GIDSignInButton) {
        print("Sign in with Google")
    }
}
