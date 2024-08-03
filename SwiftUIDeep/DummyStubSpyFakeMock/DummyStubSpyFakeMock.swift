//
//  DummyStubSpyFakeMock.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 03.08.2024.
//

import Foundation

typealias Days = Int
let REGISTERED_USER = "stub_user@gmail.com"

struct Stock {
	let symbol: String
	let quote: Quote?
}

struct Quote {
	let last: Double
	let change: Double
	let percentChange: Double
	let date: Date
}

protocol EmailService {
	func sendEmail(to mail: String, subject: String)
}

protocol DatabaseService {
	func getDaysToExpiration() -> Days
}



protocol WatchlistStore {
	func update(_ stockSymbols: [String]) throws
	func retrieve() throws -> [String]?
}

protocol QuotesService {
	func getQuotes(symbols: [String],
								 completion: @escaping (Result<[Stock], Error>) -> Void)
}



struct StockViewModel: Equatable {
	let symbol: String
	let price: String
	let percentChange: String
}

struct StockViewModelMapper {
	static func map(symbol: String) -> StockViewModel {
		StockViewModel(
			symbol: symbol,
			price: "-",
			percentChange: "-")
	}
	
	static func map(stock: Stock) -> StockViewModel {
		if let quote = stock.quote {
			return StockViewModel(
				symbol: stock.symbol,
				price: String(format: "%.2f", quote.last),
				percentChange: String(format: "%.2f", quote.percentChange) + " %")
		} else {
			return map(symbol: stock.symbol)
		}
	}
}

class WatchlistViewModel {
	//Dependencies
	private let store: WatchlistStore
	private let service: QuotesService
	
	//Properties
	static let title: String = "Watchlist"
	var isLoading: Bool
	var errorMessage: String?
	var stockViewModels: [StockViewModel]?
	
	//Initializer
	init(store: WatchlistStore, service: QuotesService) {
		self.store = store
		self.service = service
		self.isLoading = false
		self.errorMessage = nil
		self.stockViewModels = nil
	}
	
	func updateWatchlist(symbols: [String]) {
		try? store.update(symbols)
	}
	
	func getWatchlist() {
		do {
			if let symbols = try store.retrieve() {
				isLoading = true
				errorMessage = nil
				service.getQuotes(symbols: symbols) { [weak self] result in
					self?.isLoading = false
					switch result {
					case .success(let stocks):
						self?.stockViewModels = stocks.map {
							StockViewModelMapper.map(stock: $0)
						}
					case .failure(_):
						self?.stockViewModels = symbols.map {
							StockViewModelMapper.map(symbol: $0)
						}
					}
				}
			}
		} catch {
			errorMessage = "Error while getting the watchlist from the store"
		}
	}
}


class NotificationService {
	private let emailService: EmailService
	private let databaseService: DatabaseService
	
	init(emailService: EmailService, databaseService: DatabaseService) {
		self.emailService = emailService
		self.databaseService = databaseService
	}
	
	func validateStatus() {
		let days = databaseService.getDaysToExpiration()
		
		if isAboutToExpire(days){
			emailService.sendEmail(to: REGISTERED_USER,
														 subject: "Your service is close to expiration.")
		}
	}
	
	private func isAboutToExpire(_ days: Days) -> Bool {
		days < 10
	}
}
