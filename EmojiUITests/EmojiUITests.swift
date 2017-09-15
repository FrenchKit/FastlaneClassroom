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
            XCUIDevice.shared.orientation = .landscapeRight
        } else {
            XCUIDevice.shared.orientation = .portrait
        }
        
        let app = XCUIApplication()
        app.launch()
    }
    
    func testExample() {
        
    }
}
