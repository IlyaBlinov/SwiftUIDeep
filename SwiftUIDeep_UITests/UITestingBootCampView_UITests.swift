//
//  UITestingBootCampView_UITests.swift
//  SwiftUIDeep_UITests
//
//  Created by Илья Блинов on 31.07.2024.
//

import XCTest
@testable import SwiftUIDeep

// Naming Structure test_UnitOfWork_StateUnderTest_ExpectedBehaviour

// Naming Structure: test_[struct]_[ui_component]_[expected result]

// Testing Structure: Given, When, Then


final class UITestingBootCampView_UITests: XCTestCase {
	
	let app = XCUIApplication()
	
	override func setUpWithError() throws {
		continueAfterFailure = false
		//app.launchArguments = ["-UITest_startSignedIn"]
//		app.launchEnvironment = [
//			"-UITest_startSignedIn" : "true"
//		]
		app.launch()
		
	}
	
	override func tearDownWithError() throws {
		
	}
	
	func test_UITestingBootCampView_signUpButton_shouldNotSignIn() {
		// Given
		signUpAndSignin(shouldTypeOnKeybord: false)
		
		// When

		
		let navBar = app.navigationBars["Welcome"]
		// Then
		XCTAssertTrue(!navBar.exists)
	}
	
	func test_UITestingBootCampView_signUpButton_shouldSignIn() {
		
		// Given
		signUpAndSignin(shouldTypeOnKeybord: true)
		
		let navBar = app.navigationBars["Welcome"]
		// Then
		XCTAssertTrue(navBar.exists)
	}
	
	
	
	func test_SignedInHomeView_showAlertButton_shouldDisplayAlert() {
		// Given
		let app = XCUIApplication()
		
		// When
		signUpAndSignin(shouldTypeOnKeybord: true)
		
		let navBar = app.navigationBars["Welcome"]
		XCTAssertTrue(navBar.exists)
		
		tapAlertButton(shouldDismiss: false)
		
		let alert = app.alerts.firstMatch
		
		// Then
		XCTAssertTrue(alert.exists)
	}
	
	func test_SignedInHomeView_showAlertButton_shouldDisplayAlertAndDismiss() {
		// Given
		let app = XCUIApplication()
		
		// When
		signUpAndSignin(shouldTypeOnKeybord: true)
		
		let navBar = app.navigationBars["Welcome"]
		XCTAssertTrue(navBar.exists)
		
		tapAlertButton(shouldDismiss: true)
		
		let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
		
		
		// Then
		XCTAssertFalse(alertExists)
				
	}
	
	
	func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestination() {
		// Given
		let app = XCUIApplication()
		
		// When
		signUpAndSignin(shouldTypeOnKeybord: true)
		
		
		
		tapNavigationLink(shouldDismissDestination: false)
		
		let destinationtext = app.staticTexts["Destination"]
		
		// Then
		XCTAssertTrue(destinationtext.exists)
		
	}
	
	func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
		
		// Given
		let app = XCUIApplication()
		let navBar = app.navigationBars["Welcome"]
		
		// When
		signUpAndSignin(shouldTypeOnKeybord: true)
		
		
		
		tapNavigationLink(shouldDismissDestination: true)
		// Then
		XCTAssertTrue(navBar.exists)
		
		
				
	}
	
	func test_SignedInHomeView_navigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
		
		// Given
		let navBar = app.navigationBars["Welcome"]
		
		// When
		
		tapNavigationLink(shouldDismissDestination: true)
		// Then
		XCTAssertTrue(navBar.exists)
		
		
		
	}

}

// MARK: Functions
extension UITestingBootCampView_UITests {
	func signUpAndSignin(shouldTypeOnKeybord: Bool) {
		let textField = app.textFields["SignUpTextField"]
		
		// When
		textField.tap()
		if shouldTypeOnKeybord {
			let eKey = app.keys["E"]
			eKey.tap()
			let eKey2 = app.keys["e"]
			eKey2.tap()
		}
		
		
		let signUpButton = app.buttons["SignUpButton"]
		signUpButton.tap()
	}
	
	func tapAlertButton(shouldDismiss: Bool) {
		let alert = app.alerts.firstMatch
		let showAlertButton = app.buttons["ShowAlertButton"]
		showAlertButton.tap()
		
		if shouldDismiss {
			let alertOkButton = alert.scrollViews.otherElements.buttons["OK"]
			
			//sleep(1)
			let alertOkButtonExists = alertOkButton.waitForExistence(timeout: 5)
			XCTAssertTrue(alertOkButtonExists)
			alertOkButton.tap()
		}
	}
	
	func tapNavigationLink(shouldDismissDestination: Bool) {
		let navBar = app.navigationBars["Welcome"]
		
		let navLinkButton = app/*@START_MENU_TOKEN@*/.buttons["NavigationLinkToDestination"]/*[[".buttons[\"Navigate\"]",".buttons[\"NavigationLinkToDestination\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		navLinkButton.tap()
		
		if shouldDismissDestination {
			let backButton = app.navigationBars.buttons["Welcome"]
			backButton.tap()
		}
		
		
		
	}
}
