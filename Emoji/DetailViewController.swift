//
//  DetailViewController.swift
//  Emoji
//
//  Created by Julien on 18/08/2017.
//  Copyright © 2017 Sinplicity. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var emojiLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var aliasesLabel: UILabel?
    @IBOutlet weak var keywordsLabel: UILabel?

    var emoji: Emoji? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        if let emoji = emoji {
            emojiLabel?.text = emoji.value
            descriptionLabel?.text = emoji.description.capitalized
            aliasesLabel?.text = emoji.shortcodes.flatMap({":"+$0+":"}).joined(separator: ", ")
            keywordsLabel?.text = emoji.tags.joined(separator: ", ")
        } else {
            descriptionLabel?.text = "detail.nothingselected".localized
            emojiLabel?.text = "¯\\_(ツ)_/¯"
            aliasesLabel?.text = "detail.selectanemoji".localized
            keywordsLabel?.text = ""
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}
