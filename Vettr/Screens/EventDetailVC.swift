//
//  EventDetailViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/2/22.
//

import UIKit

class EventDetailVC: UITableViewController {
    
    //MARK: - Properties
    
    var selectedEvent: Event?
    var loggedInUserId: UUID?
    let eventDetailViewModel = EventDetailViewModel()
    var eventImageStore: EventImageStore!
    let supabaseAuthManager = SupabaseAuthManager()
    
    //MARK: - Outlets
    
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var addReviewButton: UIBarButtonItem!
    // Cell One
    @IBOutlet var eventImageView: UIImageView!
    // Cell Two
    @IBOutlet var eventDescriptionLabel: UILabel!
    // Cell Three
    @IBOutlet var vettrScoreLabel: UILabel!
    @IBOutlet var attendeesLabel: UILabel!
    @IBOutlet var acceptsSpeakerSubmissionsLabel: UILabel!
    // Cell Four
    @IBOutlet var notableSpeakerOneNameLabel: UILabel!
    @IBOutlet var notableSpeakerOneTitleAndCompanyLabel: UILabel!
    @IBOutlet var notableSpeakerTwoNameLabel: UILabel!
    @IBOutlet var notableSpeakerTwoTitleAndCompanyLabel: UILabel!
    @IBOutlet var notableSpeakerThreeNameLabel: UILabel!
    @IBOutlet var notableSpeakerThreeTitleAndCompanyLabel: UILabel!
    // Cell Five
    @IBOutlet var pressCoverageRatingsView: RatingsView!
    @IBOutlet var salesValueRatingsView: RatingsView!
    @IBOutlet var timeCommitmentRatingsView: RatingsView!
    @IBOutlet var attendeePresenceRatingsView: RatingsView!
    @IBOutlet var overallRoiRatingsView: RatingsView!
    @IBOutlet var overallValueRating: UILabel!
    @IBOutlet var overallValueRatingsView: RatingsView!
    // Cell Six
    // Checkboxes
    @IBOutlet var openToPressCheckmark: UIImageView!
    @IBOutlet var flexibleSpeakerCheckmark: UIImageView!
    @IBOutlet var liveAudienceQAndACheckmark: UIImageView!
    @IBOutlet var slideDeckRequiredCheckmark: UIImageView!
    @IBOutlet var livestreamedSessionsCheckmark: UIImageView!
    @IBOutlet var payToPlayCheckmark: UIImageView!
    // Checkbox Labels
    @IBOutlet var openToPressLabel: UILabel!
    @IBOutlet var flexibleSpeakerFormatsLabel: UILabel!
    @IBOutlet var liveAudienceQAndALabel: UILabel!
    @IBOutlet var slideDeckRequiredLabel: UILabel!
    @IBOutlet var livestreamedSessionsLabel: UILabel!
    @IBOutlet var payToPlayLabel: UILabel!
    // Cell Seven - Media

    // Cell Eight - Add to my events button
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let tempId = selectedEvent?.id {
            let imageToDisplay = eventImageStore.image(forKey: String(describing: tempId))
            eventImageView.image = imageToDisplay
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createRatings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Segue.showReviewView.rawValue:
                    showReviewFormView(segue: segue)
                default:
                    print("Segue not added.")
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func addToMyEventsPressed(_ sender: UIButton) {
        print("Add to my events button pressed")
    }
    
    @IBAction func addReviewButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let event = selectedEvent, let user = loggedInUserId else {
            return
        }
        
        Task {
            let reviews = await eventDetailViewModel.checkReviewCount(eventId: event.id, userId: user)
            
            if (reviews > 0) {
                // User has left review for event, print alert statement
                let alert = UIAlertController(title: nil, message: "You have already left a review for this event.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    //what will happen once the user clicks ok
                    
                }
                
                alert.addAction(action)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                performSegue(withIdentifier: Segue.showReviewView.rawValue, sender: self)
            }
        }
        
    }

}

//MARK: - Private Extension

private extension EventDetailVC {
    
    func initialize() {
        mediaCollectionView.backgroundColor = .white
        view.backgroundColor = .white

        Task {
            if let safeEventId = selectedEvent?.id {
                await eventDetailViewModel.fetchMediaForEvent(with: safeEventId)
                await eventDetailViewModel.fetchSpeakersForEvent(eventID: safeEventId)
            }
            setupLabels()
            createRatings()
            mediaCollectionView.reloadData()
        }
        if let userId = UserDefaults.standard.object(forKey: "currentUserId") as? String {
            // The currentUserId key exists in UserDefaults
            loggedInUserId = UUID(uuidString: userId)
        } else {
            // The currentUserId key does not exist in UserDefaults
            addReviewButton.isEnabled = false
            addReviewButton.tintColor = UIColor.clear
        }
    }
    
    @IBAction func unwindReviewCancel(segue: UIStoryboardSegue) {
        
    }
    
    func showReviewFormView(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? ReviewFormVC, let event = selectedEvent, let user = loggedInUserId {
            viewController.eventForReview = event
            viewController.eventImageStore = eventImageStore
            viewController.loggedInUser = user
        }
    }
    
    func createRatings() {
        guard let event = selectedEvent else {
            return
        }
        
        overallValueRatingsView.isEnabled = false
        pressCoverageRatingsView.isEnabled = false
        salesValueRatingsView.isEnabled = false
        timeCommitmentRatingsView.isEnabled = false
        attendeePresenceRatingsView.isEnabled = false
        overallRoiRatingsView.isEnabled = false
        
        let eventRating = event.EventRatings[0]
        
        pressCoverageRatingsView.rating = eventRating.pressCoverageRating
        salesValueRatingsView.rating = eventRating.salesValueRating
        timeCommitmentRatingsView.rating = eventRating.timeCommitmentRating
        attendeePresenceRatingsView.rating = eventRating.attendeePresenceRating
        overallRoiRatingsView.rating = eventRating.overallRoiRating
        overallValueRatingsView.rating = eventRating.overallValue
        
    }
    
    func setupLabels() {
        guard let event = selectedEvent else {
            return
        }

        self.navigationItem.title = event.title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: K.BrandColors.vettrBlue]
        eventDescriptionLabel.text = event.description
        vettrScoreLabel.text = String(event.EventRatings[0].vettrScore)
        
        if let safeAttendeesAmount = event.attendeesAmount {
            attendeesLabel.text = "\(String(safeAttendeesAmount / 1000))K+ Attendees"
        } else {
            attendeesLabel.text = "n/a"
        }
        
        if !event.acceptsSpeakerSubmissions {
            acceptsSpeakerSubmissionsLabel.text = "No Speaker Submissions"
        }
        
        if eventDetailViewModel.numberOfSpeakers() != 0 {
            notableSpeakerOneNameLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[0].name
            notableSpeakerOneTitleAndCompanyLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[0].title + " | " + eventDetailViewModel.eventSpeakers[0].speakers[0].company
            notableSpeakerTwoNameLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[1].name
            notableSpeakerTwoTitleAndCompanyLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[1].title + " | " + eventDetailViewModel.eventSpeakers[0].speakers[1].company
            notableSpeakerThreeNameLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[2].name
            notableSpeakerThreeTitleAndCompanyLabel.text = eventDetailViewModel.eventSpeakers[0].speakers[2].title + " | " + eventDetailViewModel.eventSpeakers[0].speakers[2].company
        } else {
            notableSpeakerOneNameLabel.isHidden = true
            notableSpeakerOneTitleAndCompanyLabel.isHidden = true
            notableSpeakerTwoNameLabel.isHidden = true
            notableSpeakerTwoTitleAndCompanyLabel.isHidden = true
            notableSpeakerThreeNameLabel.isHidden = true
            notableSpeakerThreeTitleAndCompanyLabel.isHidden = true
        }
        
        overallValueRating.text = String(Double(event.EventRatings[0].overallValue))
        
        if !event.openToPress {
            openToPressCheckmark.isHidden = true
            openToPressLabel.textColor = .lightGray
        }
        
        if !event.flexibleSpeakerFormats {
            flexibleSpeakerCheckmark.isHidden = true
            flexibleSpeakerFormatsLabel.textColor = .lightGray
        }
        
        if !event.liveAudienceQAndA {
            liveAudienceQAndACheckmark.isHidden = true
            liveAudienceQAndALabel.textColor = .lightGray
        }
        
        if !event.slideDeckRequired {
            slideDeckRequiredCheckmark.isHidden = true
            slideDeckRequiredLabel.textColor = .lightGray
        }
        
        if !event.liveStreamedSessions {
            livestreamedSessionsCheckmark.isHidden = true
            livestreamedSessionsLabel.textColor = .lightGray
        }
        
        if !event.payToPlay {
            payToPlayCheckmark.isHidden = true
            payToPlayLabel.textColor = .lightGray
        }
        
    }
}

extension EventDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return eventDetailViewModel.numberOfMediaItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let media = eventDetailViewModel.media[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaImageCell", for: indexPath) as! MediaImageCell
        
        cell.setMediaImageCell(media: media)
        
        return cell
    }
}

extension EventDetailVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.size.width - 20)/CGFloat(eventDetailViewModel.numberOfMediaItems()), height: (collectionView.frame.size.height))
    }
}
