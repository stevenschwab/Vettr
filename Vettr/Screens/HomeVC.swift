//
//  HomeViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 10/29/22.
//

import UIKit

class HomeVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var upcomingEventsButton: UIButton!
    @IBOutlet var categoryButtonsWithIcons: [UIButton]!
    @IBOutlet var categoryButtonsWithoutIcons: [UIButton]!
    @IBOutlet var topEventsButtons: [UIButton]!
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    var selectedEvent: Event!
    var events: [Event] = []
    var range = 9
    var hasMoreEvents = true
    
    let searchBar = VRSearchBar()
    var eventImageStore: EventImageStore!
    
    var isSearchTextEntered: Bool { return !searchBar.text!.isEmpty }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case Segue.showEventDetailView.rawValue:
                showEventDetailView(segue: segue)
            case Segue.showSearchView.rawValue:
                showSearchView(segue: segue)
            default:
                print("Segue not added.")
        }
    }
    
}

//MARK: - Private Extension

private extension HomeVC {
    func configureViewController() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor.white
    }
    
    func getEvents(range: Int) async {
        showLoadingView()
        await NetworkManager.shared.fetchEventsBy(range: range) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let events):
                if events.count < 9 { self.hasMoreEvents = false }
                self.events.append(contentsOf: events)
                
                if self.events.isEmpty {
                    let message = "No events."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.collectionView.reloadData()
                
            case .failure(let error):
                self.presentVRAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func initialize() {
        searchBar.text = nil
        tabBarController?.tabBar.isHidden = false
        setButtonDefaults()
        createDismissKeyboardTapGesture()
        Task {
            await getEvents(range: range)
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapToHideKeyboard(sender:)))
        tap.numberOfTapsRequired = 1
        tap.isEnabled = true
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapToHideKeyboard(sender: UITapGestureRecognizer) {
        self.searchBar.endEditing(true)
    }
    
    func setButtonDefaults() {
        categoryButtonsWithIcons.forEach {
            $0.setBackgroundColor(K.BrandColors.vettrBlue, for: .selected)
            $0.setBackgroundColor(.lightGray, for: .normal)
        }
        categoryButtonsWithIcons.first?.isSelected = true
        
        categoryButtonsWithoutIcons.forEach {
            $0.setTitleColor(K.BrandColors.vettrBlue, for: .selected)
            $0.setTitleColor(.lightGray, for: .normal)
        }
        categoryButtonsWithoutIcons.first?.isSelected = true
        
        topEventsButtons.forEach {
            $0.setTitleColor(.white, for: .selected)
            $0.setBackgroundColor(K.BrandColors.vettrBlue, for: .selected)
            $0.setTitleColor(.lightGray, for: .normal)
        }
        topEventsButtons.first?.isSelected = true
    }
    
    func showEventDetailView(segue: UIStoryboardSegue) {
        guard let event = selectedEvent else { return }
        
        if let eventDetailVC = segue.destination as? EventDetailVC {
            eventDetailVC.selectedEvent = event
            eventDetailVC.eventImageStore = eventImageStore
        }
    }
    
    //MARK: - Actions
    
    @IBAction func topEventButtonTapped(_ sender: UIButton) {
        
        // Get Category selected
        let selectedCategory = categoryButtonsWithIcons.filter { (category) in
            category.isSelected
        }
        
        filterEventsBy(category: selectedCategory[0].currentTitle!, by: sender.currentTitle!)
        
        // Change color
        topEventsButtons.forEach {
            $0.isSelected = ($0 == sender)
        }
    }
    
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        
        // Get current filter selected
        let selectedFilter = topEventsButtons.filter { (filter) in
            filter.isSelected
        }
        
        filterEventsBy(category: sender.currentTitle!, by: selectedFilter[0].currentTitle!)
        
        // Change button color
        categoryButtonsWithIcons.forEach {
            if let safeTitle = sender.currentTitle {
                $0.isSelected = ($0.currentTitle == safeTitle)
            } else {
                print("Error: button \(sender) has no title")
            }
        }
        
        // Change button color
        categoryButtonsWithoutIcons.forEach {
            if let safeTitle = sender.currentTitle {
                $0.isSelected = ($0.currentTitle == safeTitle)
            } else {
                print("Error: button \(sender) has no title")
            }
        }
    }
    
    func filterEventsBy(category: String, by filter: String) {
        Task {
            await homeViewModel.fetchEventsBy(category: category, filter: filter)
            collectionView.reloadData()
        }
    }

}

//MARK: - Event CollectionView DataSource Methods

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return homeViewModel.numberOfHomeItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let event = homeViewModel.events[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCell

        cell.setHomeCell(event: event)
        
        return cell
    }
}

//MARK: - Event CollectionView Delegate Methods

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let event = homeViewModel.events[indexPath.row]
        
        Task {
            // Download the image data, which could take some time
            await eventImageStore.fetchEventImage(for: event) { (result) -> Void in
                // The index path for the event might have changed between the time the request started and finished, so find the most recent index path
                guard let eventIndex = self.homeViewModel.events.firstIndex(of: event), case let .success(image) = result else {
                    return
                }
                let eventIndexPath = IndexPath(item: eventIndex, section: 0)
                
                // When the request finishes, find the current cell for this event
                if let cell = self.collectionView.cellForItem(at: eventIndexPath) as? HomeCell {
                    cell.update(displaying: image)
                }
            }
        }
    }
    
    // When user taps a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        
        selectedEvent = homeViewModel.homeItem(at: indexPath.row)
        
        performSegue(withIdentifier: Segue.showEventDetailView.rawValue, sender: self)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreEvents else { return }
            range += 9
            getEvents(range: range)
        }
    }
}

//MARK: - Event Collection View Delegate Flow Layout

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.size.width - 20)/2, height: (collectionView.frame.size.height))
    }
}

//MARK: - Search bar delegate methods

extension HomeVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isSearchTextEntered else {
            // No search text
            return
        }
        
        searchBar.resignFirstResponder()
        
        performSegue(withIdentifier: Segue.showSearchView.rawValue, sender: self)
    }
    
    func showSearchView(segue: UIStoryboardSegue) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.searchRequest = searchBar.text
            searchVC.eventImageStore = eventImageStore
        }
    }
    
}
