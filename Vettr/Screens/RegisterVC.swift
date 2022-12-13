//
//  RegisterViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/1/22.
//

import UIKit

class RegisterVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var agreeToTermsCheckBox: Checkbox!
    
    let supabaseAuthManager = SupabaseAuthManager()
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

private extension RegisterVC {
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
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, agreeToTermsCheckBox.isChecked else {
            return
        }
        
        Task {
            await supabaseAuthManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                
                if (success) {
                    
                    let alert = UIAlertController(title: nil, message: "Please verify your email.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        //what will happen once the user clicks ok
                        
                    }
                    
                    alert.addAction(action)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {
                    let alert = UIAlertController(title: nil, message: "There was an error.", preferredStyle: .alert)
                    
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
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.showLoginViewFromRegisterView.rawValue, sender: self)
    }
}
