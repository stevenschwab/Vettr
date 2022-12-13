//
//  mediaImageCell.swift
//  Vettr
//
//  Created by Steven Schwab on 11/18/22.
//

import UIKit

class MediaImageCell: UICollectionViewCell {
    
    @IBOutlet var mediaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setMediaImageCell(media: Media) {
        mediaImageView.image = UIImage(named: media.MediaTypes.logo)!
    }
}
