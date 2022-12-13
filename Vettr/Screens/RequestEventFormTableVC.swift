//
//  RequestEventFormTableViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/7/22.
//

import UIKit

class RequestEventFormTableVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var opportunityNameTextField: UITextField!
    @IBOutlet var opportunityTypeTextField: UITextField!
    @IBOutlet var opportunityURLTextField: UITextField!
    @IBOutlet var yourEmailTextField: UITextField!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    var opportunityTypeManager = RequestNewEventViewModel()
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

}

private extension RequestEventFormTableVC {
    
    func initialize() {
        view.backgroundColor = .white
        opportunityNameTextField.attributedPlaceholder = NSAttributedString(string: "Opportunity Name", attributes: [.foregroundColor: UIColor.black])
        opportunityTypeTextField.attributedPlaceholder = NSAttributedString(string: "Opportunity Type", attributes: [.foregroundColor: UIColor.black])
        opportunityURLTextField.attributedPlaceholder = NSAttributedString(string: "Opportunity URL", attributes: [.foregroundColor: UIColor.black])
        yourEmailTextField.attributedPlaceholder = NSAttributedString(string: "Your Email", attributes: [.foregroundColor: UIColor.black])
        
        submitButton.isEnabled = false
        
        // Add a target-action pair to the opportunityNameTextField
        opportunityNameTextField.addTarget(self, action: #selector(updateSubmitButtonState), for: .editingChanged)
        
        // Add a target-action pair to the opportunityTypeTextField
        opportunityTypeTextField.addTarget(self, action: #selector(updateSubmitButtonState), for: .editingChanged)
        
        // Add a target-action pair to the opportunityURLTextField
        opportunityURLTextField.addTarget(self, action: #selector(updateSubmitButtonState), for: .editingChanged)
        
        // Add a target-action pair to the yourEmailTextField
        yourEmailTextField.addTarget(self, action: #selector(updateSubmitButtonState), for: .editingChanged)
        
        createDismissKeyboardTapGesture()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
        // Check if all four text fields are non-empty
        
        guard let safeOpportunityNameTextField = opportunityNameTextField.text,
           let safeOpportunityTypeTextField = opportunityTypeTextField.text,
           let safeOpportunityURLTextField = opportunityURLTextField.text,
              let safeYourEmailTextField = yourEmailTextField.text else {
            return
        }
        
        Task {
            await opportunityTypeManager.createOpportunityRequest(
                withName: safeOpportunityNameTextField,
                withOppType: safeOpportunityTypeTextField,
                withURL: safeOpportunityURLTextField,
                withEmail: safeYourEmailTextField
            )
        }
            
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateSubmitButtonState() {
        // Check if all four text fields are non-empty
        if let safeOpportunityNameTextField = opportunityNameTextField.text,
           let safeOpportunityTypeTextField = opportunityTypeTextField.text,
           let safeOpportunityURLTextField = opportunityURLTextField.text,
              let safeYourEmailTextField = yourEmailTextField.text {
            
            let allFieldsAreNonEmpty = !safeOpportunityNameTextField.isEmpty &&
                                           !safeOpportunityTypeTextField.isEmpty &&
                                           !safeOpportunityURLTextField.isEmpty &&
                                           !safeYourEmailTextField.isEmpty
            
            submitButton.isEnabled = allFieldsAreNonEmpty
        }
        
    }
}
