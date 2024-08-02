//
//  NewMockDataService.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 30.07.2024.
//

import Foundation
import Combine
import SwiftUI


protocol NewDataServiceProtocol {
	func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> Void)
	func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
	
	let items: [String]
	
	init(items: [String]?) {
		self.items = items ?? ["ONE", "TWO", "THREE"]
	}
	
	func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
			completion(items)
		}
	}
	
	func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
		Just(items)
			.tryMap( { publishedItems in
				guard !publishedItems.isEmpty else {
					throw URLError(.badServerResponse)
				}
				return publishedItems
			}
			)
			.eraseToAnyPublisher()
	}
}
