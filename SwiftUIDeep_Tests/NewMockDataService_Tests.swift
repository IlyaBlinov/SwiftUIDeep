//
//  NewMockDataService_Tests.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 30.07.2024.
//

import XCTest
@testable import SwiftUIDeep
import Combine

final class NewMockDataService_Tests: XCTestCase {
	
	var cancellable = Set<AnyCancellable>()
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func test_NewMockDataService_init_doesSetValuesCorrectly() {
		// Given
		let items: [String]? = nil
		let items2: [String]? = []
		let items3: [String] = [UUID().uuidString, UUID().uuidString]
		// When
		let dataService = NewMockDataService(items: items)
		let dataService2 = NewMockDataService(items: items2)
		let dataService3 = NewMockDataService(items: items3)
		// Then
		XCTAssertFalse(dataService.items.isEmpty)
		XCTAssertTrue(dataService2.items.isEmpty)
		XCTAssertEqual(dataService3.items.count, items3.count)
	}
	
	
	func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues() {
		// Given
		let dataService = NewMockDataService(items: nil)
		// When
		var items: [String] = []
		let expectation = XCTestExpectation(description: "downloadItemsWithEscaping")
		dataService.downloadItemsWithEscaping { returnedItems in
			expectation.fulfill()
			items = returnedItems
		}
		// Then
		wait(for: [expectation], timeout: 5)
		
		XCTAssertEqual(items.count, dataService.items.count)
	}
	
	func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues() {
		// Given
		let dataService = NewMockDataService(items: nil)
		// When
		var items: [String] = []
		let expectation = XCTestExpectation(description: "downloadItemsWithCombine")
		dataService.downloadItemsWithCombine().sink
		{ comletion in
			switch comletion {
			case .finished:
				expectation.fulfill()
			case .failure:
				XCTFail()
			}
		}
		receiveValue: { returnedItems in
			
			items = returnedItems
		}.store(in: &cancellable)

		// Then
		wait(for: [expectation], timeout: 5)
		
		XCTAssertEqual(items.count, dataService.items.count)
	}
	
	func test_NewMockDataService_downloadItemsWithCombine_doesFail() {
		// Given
		let dataService = NewMockDataService(items: [])
		// When
		var items: [String] = []
		let expectation = XCTestExpectation(description: "does throw an error")
		let expectation2 = XCTestExpectation(description: "Does throw URLError.badServerResponse")
		dataService.downloadItemsWithCombine().sink
		{ comletion in
			switch comletion {
			case .finished:
				XCTFail()
			case .failure(let error):
				expectation.fulfill()
				
				let urlError = error as? URLError
				XCTAssertEqual(urlError, URLError(.badServerResponse))
				
				if urlError == URLError(.badServerResponse) {
					expectation2.fulfill()
				}
			}
		}
	receiveValue: { returnedItems in
		
		items = returnedItems
	}.store(in: &cancellable)
		
		// Then
		wait(for: [expectation, expectation2], timeout: 5)
		
		XCTAssertEqual(items.count, dataService.items.count)
	}
	
}
