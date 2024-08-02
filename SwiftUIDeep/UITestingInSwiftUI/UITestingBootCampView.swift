//
//  UITestingBootCampView.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 31.07.2024.
//

import SwiftUI

class UITestingBootCampViewModel: ObservableObject {
	
	let placeholderText: String = "Add your name..."
	
	@Published var textFieldText: String = ""
	@Published var currentUserIsSignedIn: Bool
	
	init(currentUserIsSignedIn: Bool) {
		self.currentUserIsSignedIn = currentUserIsSignedIn
	}
	
	func sighUpButtonPressed() {
		guard  !textFieldText.isEmpty else { return }
		currentUserIsSignedIn = true
	}
}



struct UITestingBootCampView: View {
	
	@StateObject var vm: UITestingBootCampViewModel
	
	init(currentUserIsSignedIn: Bool) {
		
		self._vm = StateObject(wrappedValue: UITestingBootCampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
	}
	
	var body: some View {
		ZStack {
			LinearGradient(
				colors: [.blue, .black],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			ZStack {
				if vm.currentUserIsSignedIn {
					SignedInHomeView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.transition(.move(edge: .trailing))
				}
				
				if !vm.currentUserIsSignedIn {
					signUpLayer
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.transition(.move(edge: .leading))
				}
			}
			
			
		}
		
	}
}

#Preview {
	UITestingBootCampView(currentUserIsSignedIn: true)
}


extension UITestingBootCampView {
	private var signUpLayer: some View {
		VStack {
			TextField(vm.placeholderText, text: $vm.textFieldText)
				.font(.headline)
				.padding()
				.background(Color.white)
				.cornerRadius(10)
				.accessibilityIdentifier("SignUpTextField")
			
			Button(action: {
				withAnimation(.spring) {
					vm.sighUpButtonPressed()
				}
			}, label: {
				Text("Sign Up")
					.font(.headline)
					.padding()
					.frame(maxWidth: .infinity)
					.foregroundColor(.white)
					.background(Color.blue)
					.cornerRadius(10)
			})
			.accessibilityIdentifier("SignUpButton")
		}
		.padding()
	}
}



struct SignedInHomeView: View {
	
	@State private var showAlert: Bool = false
	
	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				
				
				Button(action: {
					showAlert.toggle()
				}, label: {
					Text("Show Welcome Alert!")
						.font(.headline)
						.padding()
						.frame(maxWidth: .infinity)
						.foregroundColor(.white)
						.background(Color.red)
						.cornerRadius(10)
				})
				.accessibilityIdentifier("ShowAlertButton")
				.alert(isPresented: $showAlert, content: {
					return Alert(title: Text("Welcome to the app!"))
				})
				
				NavigationLink(destination: Text("Destination")) {
					Text("Navigate")
						.font(.headline)
						.padding()
						.frame(maxWidth: .infinity)
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("NavigationLinkToDestination")
				
			}
			.padding()
			.navigationTitle("Welcome")
		}
		
	}
}
