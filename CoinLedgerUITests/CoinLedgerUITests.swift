//
//  CoinLedgerUITests.swift
//  CoinLedgerUITests
//
//  Created by GICHUKI on 26/04/2025.
//

import XCTest

final class CoinLedgerUITests: XCTestCase {
    
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
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    @MainActor
    func testInitialAppViewsArePresent() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Assert the "Top Coins" text is visible
        let topCoinsText = app.staticTexts["Top Coins"]
        XCTAssertTrue(topCoinsText.waitForExistence(timeout: 2), "\"Top Coins\" label should be visible on launch")
        
        // Switch to Favourite Coins tab
        let tabBar = app.tabBars["Tab Bar"]
        let favoritesTab = tabBar.buttons["Favourites"]
        XCTAssertEqual(favoritesTab.label, "Favourites")
        
        
        // Assert the "Favourite Coins" text is visible after switching to the Favourites screen
        favoritesTab.tap()
        let favoritesText = app.staticTexts["Favourite Coins"]
        XCTAssertTrue(favoritesText.waitForExistence(timeout: 2), "\"Favourite Coins\" label should be visible after switching tabs")
        
        // Switch back to Top Coins
        let topCoinsTab = tabBar.buttons["Top Coins"]
        XCTAssertTrue(topCoinsTab.exists, "Top Coins tab should exist")
        topCoinsTab.tap()
        
        // Assert the "Top Coins" label is visible again
        XCTAssertTrue(topCoinsText.waitForExistence(timeout: 2), "\"Top Coins\" label should be visible after switching back")
    }
}
