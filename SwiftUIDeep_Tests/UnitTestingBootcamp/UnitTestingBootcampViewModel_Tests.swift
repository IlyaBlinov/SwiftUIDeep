//
//  UnitTestingBootcampViewModel_Tests.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 27.07.2024.
//

import XCTest
import Combine
@testable import  SwiftUIDeep
// Naming Structure test_UnitOfWork_StateUnderTest_ExpectedBehaviour

// Naming Structure: test_[struct or class]_[variable or function]_[expected result]

// Testing Structure: Given, When, Then

final class UnitTestingBootcampViewModel_Tests: XCTestCase {
	
	var viewModel: UnitTestingBootcampViewModel?
	
	var cancellables = Set<AnyCancellable>()
	
	override func setUpWithError() throws {
		viewModel = UnitTestingBootcampViewModel(isPremium: Bool.random())
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		viewModel = nil
	}
	
	func test_UnitTestingBootcampViewModel_isPremium_shouldBeTrue() {
		// Given
		let userIsPremium: Bool = true
		// When
		let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
		// Then
		XCTAssertTrue(vm.isPremium)
		
	}
	
	func test_UnitTestingBootcampViewModel_isPremium_shouldBeFalse() {
		// Given
		let userIsPremium: Bool = false
		// When
		let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
		// Then
		XCTAssertFalse(vm.isPremium)
		
	}
	
	func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue() {
		// Given
		let userIsPremium: Bool = Bool.random()
		// When
		let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
		// Then
		XCTAssertEqual(vm.isPremium, userIsPremium)
		
	}
	
	func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue_stress() {
		
		for _ in 0..<100 {
			// Given
			let userIsPremium: Bool = Bool.random()
			// When
			let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
			// Then
			XCTAssertEqual(vm.isPremium, userIsPremium)
		}
	}
	
	func test_UnitTestingBootcampViewModel_dataArray_shouldBeEmpty() {
		
		// Given
		
		// When
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// Then
		XCTAssertTrue(vm.dataArray.isEmpty)
	}
	
	
	func test_UnitTestingBootcampViewModel_dataArray_shouldAddItems() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// When
		
		let loopCount: Int = Int.random(in: 0..<100)
		
		for _ in 0..<loopCount {
			vm.addItem(UUID().uuidString)
		}
		// Then
		XCTAssertTrue(!vm.dataArray.isEmpty)
		XCTAssertEqual(vm.dataArray.count, vm.dataArray.count)
	}
	
	func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// When
		vm.addItem("")
		// Then
		XCTAssertTrue(vm.dataArray.isEmpty)
	}
	
	func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlankString2() {
		
		// Given
		guard let vm = viewModel else {
			XCTFail()
			return
		}
		// When
		vm.addItem("")
		// Then
		XCTAssertTrue(vm.dataArray.isEmpty)
	}
	
	func test_UnitTestingBootcampViewModel_selectedItem_shouldStartNil() {
		
		// Given
		
		// When
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// Then
		XCTAssertNil(vm.selectedItem)
	}
	
	func test_UnitTestingBootcampViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// When
		vm.selectItem(UUID().uuidString)
		// Then
		XCTAssertNil(vm.selectedItem)
	}
	
	func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		// When
		let newItem = UUID().uuidString
		vm.addItem(newItem)
		vm.selectItem(newItem)
		// Then
		XCTAssertNotNil(vm.selectedItem)
	}
	
	func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected_stress() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		
		let loopCount: Int = Int.random(in: 0..<100)
		var itemsArray: [String] = []
		
		for _ in 0..<loopCount {
			let newItem = UUID().uuidString
			vm.addItem(newItem)
			itemsArray.append(newItem)
		}
		
		let randomItem = itemsArray.randomElement() ?? ""
		vm.selectItem(randomItem)
		
		
		// Then
		XCTAssertNotNil(vm.selectedItem)
		XCTAssertEqual(vm.selectedItem, randomItem)
	}
	
	func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_itemNotFound() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		let loopCount: Int = Int.random(in: 0..<100)
		
		for _ in 0..<loopCount {
			vm.addItem(UUID().uuidString)
		}
		
		// Then
		XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString))
		
		XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found error!") { error in
			let returnedError = error as? UnitTestingBootcampViewModel.DataError
			XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.itemNotFound)
		}
	}
	
	func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_noData() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		let loopCount: Int = Int.random(in: 0..<100)
		
		for _ in 0..<loopCount {
			vm.addItem(UUID().uuidString)
		}
		
		// Then
		XCTAssertThrowsError(try vm.saveItem(item: ""))
		
		
		do {
			try vm.saveItem(item: "")
		} catch let error {
			let returnedError = error as? UnitTestingBootcampViewModel.DataError
			XCTAssertEqual(returnedError, UnitTestingBootcampViewModel.DataError.noData)
		}
		
	
	}
	
	
	func test_UnitTestingBootcampViewModel_saveItem_shouldSaveItem() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		let loopCount: Int = Int.random(in: 0..<100)
		
		var itemsArray: [String] = []
		
		for _ in 0..<loopCount {
			let item = UUID().uuidString
			vm.addItem(item)
			itemsArray.append(item)
		}
		
		let randomItem = itemsArray.randomElement() ?? ""
		
		XCTAssertFalse(randomItem.isEmpty)
		
		// Then
		XCTAssertNoThrow(try vm.saveItem(item: randomItem))
		
		do {
			try vm.saveItem(item: randomItem)
		} catch {
			XCTFail()
		}
		
	}
	
	func test_UnitTestingBootcampViewModel_sdownloadWithEscaping_shouldReturnItems() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		let expectation = XCTestExpectation(description: "Should return items after 3 sec.")
		
		vm.$dataArray
			.dropFirst()
			.sink { items in
				expectation.fulfill()
			}.store(in: &cancellables)
		
		vm.downloadWithEscaping()
		

		
		// Then
		wait(for: [expectation], timeout: 5)
		XCTAssertGreaterThan(vm.dataArray.count, 0)
	}
	
	func test_UnitTestingBootcampViewModel_sdownloadWithCombine_shouldReturnItems() {
		
		// Given
		let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
		
		// When
		let expectation = XCTestExpectation(description: "Should return items after 2 sec.")
		
		vm.$dataArray
			.dropFirst()
			.sink { items in
				expectation.fulfill()
			}.store(in: &cancellables)
		
		vm.downloadWithCombine()
		
		
		
		// Then
		wait(for: [expectation], timeout: 5)
		XCTAssertGreaterThan(vm.dataArray.count, 0)
	}
	
	
}
