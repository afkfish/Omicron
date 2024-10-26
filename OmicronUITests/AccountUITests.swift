//
//  OmicronUITests.swift
//  OmicronUITests
//
//  Created by Beni Kis on 2024. 10. 25..
//

import XCTest

final class AccountUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments += ["--reset-state", "--testing"]
        app.launch()
    }

    @MainActor
    func testDismissLogin() throws {
        app.buttons["DismissLogin"].tap()
        
        XCTAssert(app.staticTexts["Browse"].exists)
    }
    
    @MainActor
    func testLogin() throws {
        app.buttons["Login"].tap()
        XCTAssert(app.textFields["emailField"].exists)
        
        app.textFields["emailField"].tap()
        app.textFields["emailField"].typeText("test@test.com")
        
        app.secureTextFields["passwordField"].tap()
        app.secureTextFields["passwordField"].typeText("testtest")
        
        app.buttons["submitButton"].tap()
        
        sleep(3)
        
        XCTAssert(app.staticTexts["Browse"].exists)
    }
    
    @MainActor
    func testRegister() throws {
        app.buttons["Register"].tap()
        XCTAssert(app.textFields["usernameField"].exists)
        
        app.textFields["usernameField"].tap()
        app.textFields["usernameField"].typeText(UUID().uuidString)
        
        app.textFields["emailField"].tap()
        app.textFields["emailField"].typeText("\(UUID().uuidString)@test.com")
        
        app.secureTextFields["passwordField"].tap()
        app.secureTextFields["passwordField"].typeText(UUID().uuidString)
        
        app.buttons["submitButton"].tap()
        
        sleep(3)
        
        XCTAssert(app.staticTexts["Browse"].exists)
    }
}
