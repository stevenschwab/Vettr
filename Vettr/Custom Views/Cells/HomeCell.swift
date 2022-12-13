//
//  HomeCell.swift
//  Vettr
//
//  Created by Steven Schwab on 11/8/22.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet var homeNameImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var homeNameLabel: UILabel!
    @IBOutlet var homeVettrScore: UILabel!
    @IBOutlet var homeHighestValuedRatingLabel: UILabel!
    @IBOutlet var homeHighestValuedRating: UILabel!
    @IBOutlet var homeHighestValuedStarImageView: RatingsView!
    @IBOutlet var secondHighestValuedRatingLabel: UILabel!
    @IBOutlet var secondHighestValuedRating: UILabel!
    @IBOutlet var secondHighestValuedStarImageView: RatingsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(displaying: nil)
    }
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            homeNameImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            homeNameImageView.image = nil
        }
    }
    
    func setHomeCell(event: Event) {
        homeNameLabel.text = event.title
        homeVettrScore.text = "Vettr Score: \(String(describing: event.EventRatings[0].vettrScore))"
        homeHighestValuedRatingLabel.text = "\(String(event.TopTwoEventRatings[0].ratings[0].name))"
        homeHighestValuedRating.text = "(\(String(describing: event.TopTwoEventRatings[0].ratings[0].rating))/5)"
        homeHighestValuedStarImageView.isEnabled = false
        homeHighestValuedStarImageView.rating = event.TopTwoEventRatings[0].ratings[0].rating
        secondHighestValuedRatingLabel.text = "\(String(describing: event.TopTwoEventRatings[0].ratings[1].name))"
        secondHighestValuedRating.text = "(\(String(describing: event.TopTwoEventRatings[0].ratings[1].rating))/5)"
        secondHighestValuedStarImageView.rating = event.TopTwoEventRatings[0].ratings[1].rating
        secondHighestValuedStarImageView.isEnabled = false
    }

}
