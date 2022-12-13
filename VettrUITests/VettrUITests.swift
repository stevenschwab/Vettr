//
//  VettrUITests.swift
//  VettrUITests
//
//  Created by Steven Schwab on 12/9/22.
//

import XCTest

final class VettrUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLoggedOutProfileScreen() throws {
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
    }

    func testUserCanLogIn() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        
        let profileTab = tabBar.buttons["Profile"]
        XCTAssertTrue(profileTab.exists)
        
        profileTab.tap()
        
        let loginWithEmailButton = app.buttons["Login With Email"]
        XCTAssertTrue(loginWithEmailButton.exists)
        
        loginWithEmailButton.tap()
        
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.element.exists)
        
        let emailField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".cells.textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(emailField.exists)
        
        emailField.tap()
        emailField.typeText("schwabs@umich.edu")
        
        let passwordSecureTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells.secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(passwordSecureTextField.exists)
        
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123456")
        
        let logInButton = app.staticTexts["Log in"]
        XCTAssertTrue(logInButton.exists)
        
        logInButton.tap()

        let logOutButton = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Log Out"]/*[[".cells.staticTexts[\"Log Out\"]",".staticTexts[\"Log Out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(logOutButton.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
