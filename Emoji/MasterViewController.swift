//
//  MasterViewController.swift
//  Emoji
//
//  Created by Julien on 25/08/2017.
//  Copyright © 2017 Sinplicity. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {
    var detailViewController: DetailViewController?
    var objects = [Emoji]()

    var groupedObjects = [EmojiGroup: [Emoji]]()
    var sections = [EmojiGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmojis()

        self.title = "master.title".localized

        self.collectionView?.accessibilityIdentifier = "emojisList"

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    func emoji(atIndexPath indexPath: IndexPath) -> Emoji {
        let section = sections[indexPath.section]
        return groupedObjects[section]![indexPath.row]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.emoji = self.emoji(atIndexPath: indexPath)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let collectionViewWidth = self.collectionView?.frame.size.width,
        let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let optimalWidth: CGFloat = 100
        let itemWidth = optimalWidth

        let itemsPerRow: CGFloat = floor(collectionViewWidth/(optimalWidth))
        let remainingSpace = (collectionViewWidth - (itemWidth * itemsPerRow))

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = remainingSpace / (itemsPerRow - 1.0)
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedObjects[sections[section]]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MasterCollectionViewCell", for: indexPath) as! MasterCollectionViewCell
        cell.setup(withEmoji: self.emoji(atIndexPath: indexPath))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MasterCollectionHeaderView", for: indexPath) as! MasterCollectionHeaderView
        view.titleLabel.text = self.sections[indexPath.section].displayLabel()

        return view
    }
}

extension MasterViewController {
    fileprivate func getAvailableHexCodes() -> [String] {
        guard let jsonUrl = Bundle.main.url(forResource: "versions", withExtension: "json") else {
            print("Error: unable to find versions.json.")
            return [String]()
        }
        guard let jsonData = try? Data(contentsOf:jsonUrl) else {
            print("Error: unable to read versions.json.")
            return [String]()
        }
        guard let json = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:[String]] else {
            print("Error: unable to parse versions.json.")
            return [String]()
        }

        var availableCodes = [String]()

        for key in json.keys {
            if let doubleVal = Double(key),
                doubleVal <= 9.0 {
                json[key]?.forEach({availableCodes.append($0)})
            }
        }

        return availableCodes

    }

    fileprivate func loadEmojis() {

        guard let jsonUrl = Bundle.main.url(forResource: "emoji", withExtension: "json") else {
            print("Error: unable to find emoji.json.")
            return
        }
        guard let jsonData = try? Data(contentsOf:jsonUrl) else {
            print("Error: unable to read emoji.json.")
            return
        }
        guard let json = (try? JSONSerialization.jsonObject(with: jsonData)) as? [[String:Any]] else {
            print("Error: unable to parse emoji.json.")
            return
        }

        for jsonItem in json {
            objects.append(Emoji(dictionary: jsonItem))
        }

        let availableEmojisHexCodes = getAvailableHexCodes()

        objects = objects.filter {(availableEmojisHexCodes.contains($0.hexcode))}

        objects.sort(by: {$0.order < $1.order})
        groupedObjects = objects.group(by: {$0.group})
        sections = groupedObjects.keys.sorted(by: {$0.rawValue < $1.rawValue})
    }
}
