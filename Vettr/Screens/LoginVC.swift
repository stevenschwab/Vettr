//
//  LoginViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/1/22.
//

import UIKit

class LoginVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let supabaseAuthManager = SupabaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
}

private extension LoginVC {
    func initialize() {
        view.backgroundColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor: K.BrandColors.vettrBlue])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor: K.BrandColors.vettrBlue])
        createDismissKeyboardTapGesture()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Task {
            
            await supabaseAuthManager.signInWithEmailAndPassword(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                
                if (success) {
                    //"User was sucessfully logged in."
                    
                    DispatchQueue.main.async {
                        //Navigate to the profile view controller logged in
                        self.performSegue(withIdentifier: Segue.showLoggedInProfileView.rawValue, sender: self)
                    }
                    
                } else {
                    //message = "There was an error."
                    let alert = UIAlertController(title: nil, message: "Error Logging In", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Try again", style: .default) { (action) in
                        //what will happen once the user clicks ok
                        self.passwordTextField.text = ""
                    }
                    
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
    }
}
