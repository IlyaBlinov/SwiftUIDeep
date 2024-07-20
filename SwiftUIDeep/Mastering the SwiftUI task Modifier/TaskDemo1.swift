//
//  Mastering the SwiftUI task Modifier.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 19.07.2024.
//

// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive
import SwiftUI

struct TaskDemo1: View {
	
	@State var message: String?
	let url = URL(string:"https://news.baidu.com")!
	
	var body: some View {
		let _ = Self._printChanges()
		VStack {
			if let message = message {
				Text(message)
			} else {
				ProgressView()
			}
		}
		.task {  // The code in the closure is executed "before" VStack appears
			do {
				var lines = 0
				for try await _ in url.lines { // Read the content of the specified URL
					lines += 1
				}
				try? await Task.sleep(nanoseconds: 1_000_000_000) // Simulate more complex tasks
				print("Received \(lines) lines")
				message = "Received \(lines) lines"
			} catch {
				message = "Failed to load data"
			}
		}
	}
}

#Preview {
	TaskDemo1()
}
