//
//  MasterCollectionViewCell.swift
//  Emoji
//
//  Created by Julien on 06/09/2017.
//  Copyright © 2017 Sinplicity. All rights reserved.
//

import UIKit
class MasterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!

    func setup(withEmoji emoji: Emoji) {
        self.contentLabel.text = emoji.value
        self.shortCodeLabel.text = emoji.shortcodes.first ?? ""
        self.accessibilityIdentifier = emoji.hexcode
        self.isAccessibilityElement = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(red: 0.666, green: 0.666, blue: 0.666, alpha: 1)
        self.shortCodeLabel.highlightedTextColor = .black
    }
}
