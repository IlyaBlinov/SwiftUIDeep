//
//  Stub.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import Foundation
@testable import SwiftUIDeep


// Stubs provide canned answers to calls made during the test.

class WatchlistStoreStub: WatchlistStore {
	private let stockSymbols: [String]?
	private let updateError: Error?
	private let retrieveError: Error?
	
	init(stockSymbols: [String]? = nil,
			 updateError: Error? = nil,
			 retrieveError: Error? = nil) {
		self.stockSymbols = stockSymbols
		self.updateError = updateError
		self.retrieveError = retrieveError
	}
	
	func update(_ stockSymbols: [String]) throws {
		if let error = updateError {
			throw error
		}
	}
	
	func retrieve() throws -> [String]? {
		if let error = retrieveError {
			throw error
		} else {
			return stockSymbols
		}
	}
}

struct AnyError: Error {}

