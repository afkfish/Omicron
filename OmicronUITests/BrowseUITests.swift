//
//  BrowseUITests.swift
//  OmicronUITests
//
//  Created by Beni Kis on 2024. 10. 26..
//

import XCTest

final class BrowseUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--reset-state", "--testing"]
        app.launch()
        
        app.buttons["DismissLogin"].tap()
    }

    func testExample() throws {
        app.searchFields.firstMatch.tap()
        app.searchFields.firstMatch.typeText("Adventure Time")
        
        XCTAssertTrue(app.staticTexts["Adventure Time"].exists)
        
        app.staticTexts["Adventure Time"].firstMatch.tap()
        
        XCTAssert(app.buttons["AddToLibraryButton"].exists)
    }
}
