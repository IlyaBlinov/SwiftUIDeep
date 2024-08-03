//
//  DummyStubSpyFakeMock_Tests.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import XCTest
@testable import SwiftUIDeep

final class DummyStubSpyFakeMock_Tests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func test_init_stateIsClear() {
		let sut = WatchlistViewModel(store: DummyWatchlistStore(),
																 service: DummyQuotesService())
		
		XCTAssertEqual(WatchlistViewModel.title, "Watchlist")
		XCTAssertFalse(sut.isLoading)
		XCTAssertNil(sut.errorMessage)
		XCTAssertNil(sut.stockViewModels)
	}
	
	func test_getWatchlistWithoutSymbols_generatesEmptyList() {
		let sut = WatchlistViewModel(store: WatchlistStoreStub(stockSymbols: []),
																 service: DummyQuotesService())
		sut.getWatchlist()
		XCTAssertEqual(sut.stockViewModels, [])
	}
	
	func test_getWatchlistWithStoreRetrieveError_generatesErrorMessage() {
		let sut = WatchlistViewModel(store: WatchlistStoreStub(retrieveError: AnyError()),
																 service: DummyQuotesService())
		sut.getWatchlist()
		XCTAssertNotNil(sut.errorMessage)
	}
	
	func test_getWatchlistWithSymbols_callGetQuotes() {
		let stockSymbols = ["AAPL", "MSFT", "GOOG"]
		let watchlistStore = WatchlistStoreStub(stockSymbols: stockSymbols)
		let quotesService = QuotesServiceSpy()
		
		let sut = WatchlistViewModel(store: watchlistStore,
																 service: quotesService)
		sut.getWatchlist()
		
		XCTAssertEqual(quotesService.quoteCalls[0], stockSymbols)
	}
	
	func test_whenStoreIsUpdatedAndQuotesServiceFails_symbolsAreUpdated() {
		let watchlistStore = FakeWatchlistStore()
		let quotesService = QuotesServiceSpy(error: AnyError())
		let sut = WatchlistViewModel(store: watchlistStore, service: quotesService)
		
		watchlistStore.update(["AAPL"])
		sut.getWatchlist()
		
		XCTAssertEqual(sut.stockViewModels?.count, 1)
		XCTAssertEqual(sut.stockViewModels?[0].symbol, "AAPL")
		
		watchlistStore.update(["AAPL", "MSFT"])
		sut.getWatchlist()
		
		XCTAssertEqual(sut.stockViewModels?.count, 2)
		XCTAssertEqual(sut.stockViewModels?[0].symbol, "AAPL")
		XCTAssertEqual(sut.stockViewModels?[1].symbol, "MSFT")
	}
	
}
