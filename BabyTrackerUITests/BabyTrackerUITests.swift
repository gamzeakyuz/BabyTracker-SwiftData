//
//  BabyTrackerUITests.swift
//  BabyTrackerUITests
//
//  Created by gamzeakyuz on 14.12.2025.
//

import XCTest

final class BabyTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testAddFeedingLog() throws {
        let app = XCUIApplication()
        app.launch()
        let onboardingButton = app.buttons["onboardingStartButton"]
        if onboardingButton.exists {
            onboardingButton.tap()
        }
        
        let profileNameField = app.textFields["profileNameField"]
        
        if profileNameField.waitForExistence(timeout: 5) {
            profileNameField.tap()
            profileNameField.typeText("Test Baby")
            let saveProfileButton = app.buttons["saveProfileButton"]
            XCTAssertTrue(saveProfileButton.exists, "The 'Save Profile' button could not be found.")
            saveProfileButton.tap()
            
            Thread.sleep(forTimeInterval: 2.0)
        }
        
        let addButton = app.buttons["addLogButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "The profile has been created, but the (+) button is still missing.")
        XCTAssertTrue(addButton.isEnabled, "The (+) button exists but is still disabled!")
        addButton.tap()
        
        let feedingButton = app.buttons["Feeding"]
        if feedingButton.exists {
            feedingButton.tap()
            Thread.sleep(forTimeInterval: 1.0)
        }
        
        let amountField = app.textFields["amountField"]
        XCTAssertTrue(amountField.waitForExistence(timeout: 5), "Amount field not opened.")
        
        let isAppeared = amountField.waitForExistence(timeout: 10)
        
        if !isAppeared {
            print("ERROR: Amount Field could not be found! Visible elements on screen:")
            print(app.debugDescription)
        }
        
        XCTAssertTrue(isAppeared, "Amount field (TextField) could not be found in the opened window. Make sure the default selection is 'Feeding'.")
        
        amountField.tap()
        amountField.typeText("150")
        
        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.exists, "Save button could not be found.")
        saveButton.tap()
        
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Could not return to the main screen after saving.")
    }

}
