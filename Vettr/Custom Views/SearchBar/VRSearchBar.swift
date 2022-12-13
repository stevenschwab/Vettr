//
//  VRButton.swift
//  Vettr
//
//  Created by Steven Schwab on 12/10/22.
//

import UIKit

class VRSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.sizeToFit()
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Event, Award, etc ...", attributes: [.foregroundColor: K.BrandColors.vettrBlue])
        self.searchTextField.textColor = K.BrandColors.vettrBlue
    }
}
