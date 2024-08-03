//
//  Dummy.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import XCTest
@testable import SwiftUIDeep

// Dummy objects are passed around but never actually used.
// They are used to fill a required dependency of the SUT that we don’t care for our test purposes

struct DummyWatchlistStore: WatchlistStore {
	func update(_ stockSymbols: [String]) throws { }
	func retrieve() throws -> [String]? { [] }
}

struct DummyQuotesService: QuotesService {
	func getQuotes(symbols: [String],
								 completion: @escaping (Result<[Stock], Error>) -> Void) {
		completion(.success([]))
	}
}
