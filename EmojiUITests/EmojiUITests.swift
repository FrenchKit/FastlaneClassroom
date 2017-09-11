//
//  EmojiUITests.swift
//  EmojiUITests
//
//  Created by Julien on 28/08/2017.
//  Copyright © 2017 Sinplicity. All rights reserved.
//

import XCTest

class EmojiUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
    
        // Force device orientation (landscape for iPad / portrait otherwise)
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared().orientation = .landscapeRight
        } else {
            XCUIDevice.shared().orientation = .portrait
        }
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testExample() {
        
        let app = XCUIApplication()

        // TODO: Lauch Screenshot
        
        // We are looking for the collectionView
        let emojislistCollectionView = app.collectionViews["emojisList"]
        
        // Then, we tap on the 1F60E cell (1F60E is the code of the "cool" emoji)
        emojislistCollectionView.cells["1F60E"].tap()
        
        // TODO: Cool screenshot

        // Press the UINavigationBar back button
        backButton()?.tap()

        // Tap the 1F603 cell (1F60E is the code of the "Proud" emoji)
        emojislistCollectionView.cells["1F603"].tap()
        
        // TODO: Proud screenshot
        backButton()?.tap()

        
        // Let's find the nerd (1F913)
        if let bowieCell = scroll(collectionView: emojislistCollectionView, toFindCellWithId: "1F913") {
            bowieCell.tap()
            // TODO: Nerd screenshot
            backButton()?.tap()
        } else {
            XCTFail("Unable to find nerd cell :(")
        }

    }
    
    func scroll(collectionView:XCUIElement, toFindCellWithId identifier:String) -> XCUIElement? {
        guard collectionView.elementType == .collectionView else {
            fatalError("XCUIElement is not a collectionView.")
        }
  
        var reachedTheEnd = false
        var allVisibleElements = [String]()
        
        while !reachedTheEnd {
            let cell = collectionView.cells[identifier]
            
            // Did we find our cell ?
            if cell.exists {
                return cell
            }
 
            // If not: we store the list of all the elements we've got in the CollectionView
            let allElements = collectionView.cells.allElementsBoundByIndex.map({$0.identifier})
            
            // Did we read then end of the CollectionView ? 
            // i.e: do we have the same elements visible than before scrolling ?
            reachedTheEnd = (allElements == allVisibleElements)
            allVisibleElements = allElements
            
            // Then, we do a scroll up on the scrollview

            collectionView.swipeUp()
            collectionView.swipeUp()
        }
        return nil
    }
    
    
    func statusBarScrollToTop() {
        let statusBar = XCUIApplication().statusBars.element
        statusBar.doubleTap()
    }
    
    func backButton() -> XCUIElement? {
        var backButton:XCUIElement?
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Asume that the back button is the first button of the navigationbar
            backButton =  XCUIApplication().navigationBars.element.buttons.element(boundBy: 0)
        }
        return backButton
    }
    
    
}
