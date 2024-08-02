//
//  SwiftUIDeepApp.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 19.07.2024.
//

import SwiftUI

@main
struct SwiftUIDeepApp: App {
	
	let currentUserIsSignedIn: Bool
	
	init() {
//		let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
//		print("userIsSignedIn: \(userIsSignedIn)")
		self.currentUserIsSignedIn = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
		
//		self.currentUserIsSignedIn = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"] == "true" ? true : false
	}
	
	var body: some Scene {
		WindowGroup {
			UITestingBootCampView(currentUserIsSignedIn: currentUserIsSignedIn)
		}
	}
}
