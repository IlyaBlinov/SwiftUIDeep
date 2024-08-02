//
//  UnitTestingBootcampViewModel.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 27.07.2024.
//

import SwiftUI
import Combine


final class UnitTestingBootcampViewModel: ObservableObject {
	
	@Published var isPremium: Bool
	@Published var dataArray: [String] = []
	@Published var selectedItem: String? = nil
	
	let dataService: NewDataServiceProtocol
	
	var cancellable = Set<AnyCancellable>()
	
	init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
		self.isPremium = isPremium
		self.dataService = dataService
	}
	
	func addItem(_ item: String) {
		guard !item.isEmpty else { return }
		dataArray.append(item)
	}
	
	func selectItem(_ item: String) {
		if let x = dataArray.firstIndex(where: { $0 == item }) {
			self.selectedItem = item
		} else {
			self.selectedItem = nil
		}
		
	}
	
	func saveItem(item: String) throws {
		guard !item.isEmpty else { throw DataError.noData }
		if let x = dataArray.firstIndex(where: { $0 == item }) {
			print("saveItem: \(x)")
		} else {
			throw DataError.itemNotFound
		}
	}
	
	enum DataError: Error {
		case noData
		case itemNotFound
	}
	
	
	func downloadWithEscaping() {
		dataService.downloadItemsWithEscaping { [weak self] items in
			self?.dataArray = items
		}
	}
	
	func downloadWithCombine() {
		dataService.downloadItemsWithCombine()
			.sink(
				receiveCompletion: { _ in }) { [weak self] items in
					self?.dataArray = items
				}
				.store(in: &cancellable)
		
	}
	
}
