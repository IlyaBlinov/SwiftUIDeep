//
//  Spy.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import Foundation
@testable import SwiftUIDeep

class QuotesServiceSpy: QuotesService {
	private (set) var quoteCalls: [[String]] = []
	private let stocks: [Stock]
	private let error: Error?
	
	init(stocks: [Stock] = [], error: Error? = nil) {
		self.stocks = stocks
		self.error = error
	}
	
	func getQuotes(symbols: [String],
								 completion: @escaping (Result<[Stock], Error>) -> Void) {
		quoteCalls.append(symbols)
		if let error = error {
			completion(.failure(error))
		} else {
			completion(.success(stocks))
		}
	}
}
