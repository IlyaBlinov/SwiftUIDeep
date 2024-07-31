//
//  UnitTestingBootcampView.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 27.07.2024.
//

import SwiftUI


struct UnitTestingBootcampView: View {
	
	@StateObject var vm: UnitTestingBootcampViewModel
	
	init(vm: UnitTestingBootcampViewModel) {
		self._vm = StateObject(wrappedValue: vm)
	}
	
	var body: some View {
		Text(vm.isPremium.description)
	}
}


#Preview {
	UnitTestingBootcampView(vm: UnitTestingBootcampViewModel(isPremium: true))
}
