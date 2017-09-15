//
//  Emoji.swift
//  Emoji
//
//  Created by Julien on 18/08/2017.
//  Copyright © 2017 Sinplicity. All rights reserved.
//

import Foundation

class Emoji {
    let value: String
    let description: String
    let hexcode: String
    let shortcodes: [String]
    let tags: [String]
    let order: Int
    let group: EmojiGroup

    init(dictionary: [String: Any]) {
        self.value = dictionary["emoji"] as? String ?? ""
        self.description = dictionary["annotation"] as? String ?? ""
        self.order = dictionary["order"] as? Int ?? 0
        self.hexcode = dictionary["hexcode"] as? String ?? ""

        let groupValue = dictionary["group"] as? Int ?? 0

        self.group = EmojiGroup(rawValue:groupValue)!

        var tags = [String]()
        if let jsonTags =  dictionary["tags"] as? [String] {
            for tag in jsonTags {
                tags.append(tag)
            }
        }
        self.tags = tags

        var shortcodes = [String]()
        if let jsonShortCodes =  dictionary["shortcodes"] as? [String] {
            for shortcode in jsonShortCodes {
                shortcodes.append(shortcode)
            }
        }
        self.shortcodes = shortcodes
    }
}

enum EmojiGroup: Int {
    case people = 0
    case nature = 1
    case food_drink = 2
    case travel_places = 3
    case activities = 4
    case objects = 5
    case symbols = 6
    case flags = 7
    
    func displayLabel() -> String {
        return self.localizableKey().localized
    }
    
    private func localizableKey() -> String {
        switch self {
        case .people:
            return "category.0"
        case .nature:
            return "category.1"
        case .food_drink:
            return "category.2"
        case .travel_places:
            return "category.3"
        case .activities:
            return "category.4"
        case .objects:
            return "category.5"
        case .symbols:
            return "category.6"
        case .flags:
            return "category.7"
        }
    }
}
