//
//  SearchViewController.swift
//  Vettr
//
//  Created by Steven Schwab on 11/4/22.
//

import UIKit

class SearchVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var searchCountLabel: UILabel!
    
    //MARK: - Properties
    
    let searchBar = VRSearchBar()
    let searchDataViewModel = SearchDataViewModel()
    var searchRequest: String!
    var selectedEvent: Event?
    var numOfSearchItems: Int?
    var eventImageStore: EventImageStore!
    
    //MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case Segue.showEventDetailFromSearchView.rawValue:
                showEventDetailFromSearchView(segue: segue)
            default:
                print("Segue not added")
        }
    }
    
    //MARK: - Actions
    
    @IBAction func addOpportunityRequestButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.showRequestEventViewFromSearch.rawValue, sender: self)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (searchDataViewModel.numberOfEventsFromSearch != 0) {
            return searchDataViewModel.numberOfEventsFromSearch
        } else {
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchViewCell", for: indexPath) as! SearchViewCell
        
        if (searchDataViewModel.numberOfEventsFromSearch != 0) {
            
            let event = searchDataViewModel.searchItem(at: indexPath.row)
            
            cell.setSearchViewCell(event: event)
            
        } else {
            cell.setNoResults()
        }
        
        return cell

    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searchDataViewModel.numberOfEventsFromSearch != 0) {
            selectedEvent = searchDataViewModel.searchItem(at: indexPath.row)
            
            performSegue(withIdentifier: Segue.showEventDetailFromSearchView.rawValue, sender: self)
        }
            
    }
    
}

//MARK: - Private Extension
private extension SearchVC {
    func initialize() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        createDismissKeyboardTapGesture()
        
        Task {
            await searchDataViewModel.fetch(with: searchRequest!)
            await searchDataViewModel.numberOfEventsInDatabase()
            searchCountLabel.text = searchDataViewModel.setCountLabel()
            tableView.reloadData()
        }
        
        searchBar.text = searchRequest!
    
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
    
    func showEventDetailFromSearchView(segue: UIStoryboardSegue) {
        if let viewController = segue.destination as? EventDetailVC, let event = selectedEvent {
            viewController.selectedEvent = event
            viewController.eventImageStore = eventImageStore
        }
    }
        
    @IBAction func unwindRequestEventCancel(segue: UIStoryboardSegue) {
        
    }
}

//MARK: - Search bar methods

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchRequest = searchBar.text!
        initialize()
    }
}
