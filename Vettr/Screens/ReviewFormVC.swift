//
//  ReviewFormViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/7/22.
//

import UIKit

class ReviewFormVC: UITableViewController {
    
    //MARK: - Properties
    
    var eventForReview: Event?
    var loggedInUser: UUID?
    var reviewFormViewModel = ReviewFormViewModel()
    var eventImageStore: EventImageStore!
    
    //MARK: - Outlets
    // Star ratings
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var pressCoverageRatingsView: RatingsView!
    @IBOutlet var salesValueRatingsView: RatingsView!
    @IBOutlet var timeCommitmentRatingsView: RatingsView!
    @IBOutlet var attendeePresenceRatingsView: RatingsView!
    @IBOutlet var overallRoiRatingsView: RatingsView!
    // Checkboxes
    @IBOutlet var sponsorshipRequiredCheckboxButton: Checkbox!
    @IBOutlet var pressAttendanceCheckboxButton: Checkbox!
    @IBOutlet var speakerProposalsAcceptedCheckboxButton: Checkbox!
    // Text review
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var characterCountLabel: UILabel!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        if let tempId = eventForReview?.id {
            let imageToDisplay = eventImageStore.image(forKey: String(describing: tempId))
            eventImageView.image = imageToDisplay
        }
    }
    
    //MARK: - Actions
    
    @IBAction func onSaveTapped(_ sender: UIBarButtonItem) {
        
        if reviewTextView.textColor == K.BrandColors.vettrBlue {
            reviewTextView.text = nil
        }
        
        if let safeEventId = eventForReview?.id, let safeUserId = loggedInUser {
            Task {
                let result = await reviewFormViewModel.createReviewForEvent(
                    // Star ratings
                    withPressCoverageRating: pressCoverageRatingsView.rating,
                    withSalesValueRating: salesValueRatingsView.rating,
                    withTimeCommitmentRating: timeCommitmentRatingsView.rating,
                    withAttendeePresenceRating: attendeePresenceRatingsView.rating,
                    withOverallROIRating: overallRoiRatingsView.rating,
                    // Checkboxes
                    isSponsorshipRequired: sponsorshipRequiredCheckboxButton.isChecked,
                    withPressAttendance: pressAttendanceCheckboxButton.isChecked,
                    areSpeakerProposalsRequired: speakerProposalsAcceptedCheckboxButton.isChecked,
                    // User Review
                    withCustomerReview: reviewTextView.text,
                    // Metadata
                    withEventID: safeEventId,
                    withUserWhoSubmittedReview: safeUserId
                )
                
                let alert = UIAlertController(title: nil, message: "Review added successfully.", preferredStyle: .alert)
                
                if (result == "error") {
                    alert.message = "There was an error. Please try again."
                }
                
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    //what will happen once the user clicks ok
                }
                
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
}

private extension ReviewFormVC {
    func initialize() {
        view.backgroundColor = .white
        characterCountLabel.text = "280"
        if let safeEvent = eventForReview {
            self.navigationItem.title = safeEvent.title
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.BrandColors.vettrBlue]
        }
        // Textview placeholder
        reviewTextView.delegate = self
        reviewTextView.text = "Leave a review (280 character max)"
        reviewTextView.textAlignment = .center
        reviewTextView.textColor = K.BrandColors.vettrBlue
        
        createDismissKeyboardTapGesture()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension ReviewFormVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == K.BrandColors.vettrBlue {
            textView.text = nil
            textView.textAlignment = .left
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Leave a review (280 character max)"
            textView.textAlignment = .center
            textView.backgroundColor = hexStringToUIColor("efefef")
            textView.textColor = K.BrandColors.vettrBlue
        }
    }
    
    //control whether a change to the text in a UITextView should be allowed. This method is called whenever the user attempts to change the text in the UITextView, such as by typing, pasting, or deleting text.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Limit the number of characters in the text view to 280
        let maxLength = 280
        let currentString: NSString = textView.text as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the remaining character count
        let maxLength = 280
        let currentLength = textView.text.count
        let remainingLength = maxLength - currentLength
        
        // Update the character count label
        characterCountLabel.text = "\(remainingLength)"
    }
}
