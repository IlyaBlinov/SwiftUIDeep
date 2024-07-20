//
//  TaskNotificationDemo.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 20.07.2024.
//

// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive

import SwiftUI

// In the current scenario, using tasks instead of onReceive can provide two benefits:
// Reduce unnecessary view refreshes (avoid redundant calculations)
// Respond to messages on a background thread to reduce the load on the main thread



// Task cannot completely replace onReceive. For some views (views in lazy containers, views in TabViews, etc.), they may repeatedly satisfy the triggering conditions of onAppear and onDisappear (scrolling off the screen, switching between different tabs, etc.). As a result, the notificationHandler running in task will not continue to run. However, for onReceive, even if the view triggers onDisappear, as long as the view still exists, the operations in the closure will continue to be executed (necessary information will not be lost).

struct TaskNotificationDemo: View {
	@State var message = ""
	var body: some View {
		Text(message)
			.task(notificationHandler)
	}
	
	@Sendable
	func notificationHandler() async {
		for await notification in NotificationCenter.default.notifications(named: .messageSender) where !Task.isCancelled {
			// Check whether specific conditions are met.
			if let message = notification.object as? String, condition(message) {
				self.message = message
			}
		}
	}
	
	func condition(_ message: String) -> Bool { message.count > 10 }
}

extension Notification.Name {
	static let messageSender = Notification.Name("messageSender")
}


#Preview {
    TaskNotificationDemo()
}
