//
//  SearchViewCell.swift
//  Vettr
//
//  Created by Steven Schwab on 11/2/22.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    @IBOutlet var searchEventLabel: UILabel!
    @IBOutlet var searchEventType: UILabel!
    @IBOutlet var searchEventStarImageView: RatingsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSearchViewCell(event: Event) {
        searchEventLabel.text = event.title
        searchEventType.text = event.OpportunityTypes.name
        searchEventStarImageView.isHidden = false
        searchEventStarImageView.rating = event.EventRatings[0].overallValue
        searchEventStarImageView.isEnabled = false
    }
    
    func setNoResults() {
        searchEventLabel.text = "No results found"
        searchEventType.text = nil
        searchEventStarImageView.isHidden = true
    }
}
