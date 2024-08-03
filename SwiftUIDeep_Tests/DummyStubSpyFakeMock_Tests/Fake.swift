//
//  Fake.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import Foundation
@testable import SwiftUIDeep

class FakeWatchlistStore: WatchlistStore {
	private var stockSymbols: [String]?
	
	func update(_ stockSymbols: [String]) {
		self.stockSymbols = stockSymbols
	}
	
	func retrieve() -> [String]? {
		stockSymbols
	}
}
