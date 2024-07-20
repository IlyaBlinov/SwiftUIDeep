//
//  TaskDemo4WithExecutionTaskInNotMainActor.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 20.07.2024.
//
// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive
import SwiftUI


final class TestObject: ObservableObject {
	
	@Published var date: Date = .now
	@Published var show = true
	
	@Sendable
	func timer() async {
		let taskID = UUID()
		print(Thread.current)
		defer {
			print("Task \(taskID) has been cancelled.")
			// Do some cleanup work for the data
		}
		while !Task.isCancelled {
			try? await Task.sleep(nanoseconds: 1000000000)
			let now = Date.now
			await MainActor.run { // Need to switch back to the main thread
				date = now
			}
			print("Task ID \(taskID) :\(now.formatted(date: .numeric, time: .complete))")
		}
	}
}


struct TaskDemo4WithExecutionTaskInNotMainActor: View {
	
	@State var date = Date.now
	@State var show = true
	
	// In the definition of StateObject, wrappedValue and projectedValue are marked with @MainActor
	// Causes SwiftUI to infer that the instance of the view type runs on the main thread by default
	// @StateObject var testObject = TestObject() // task will be only in MainThread-
	
	var body: some View {
		VStack {
			Button(show ? "Hide Timer" : "Show Timer") {
				show.toggle()
			}
			if show {
				Text(date, format: .dateTime.hour().minute().second())
					.task(timer) // Work not in main thread, if called from class not from view if view has Source of Truth conforming to the DynamicProperty protocol
			}
		}
	}
	
	// Worked only in Main Thread, If you declare other Source of Truth conforming to the DynamicProperty protocol
	// If you do not declare other Source of Truth conforming to the DynamicProperty protocol, work in not main thread
	@Sendable
	func timer() async {
		let taskID = UUID()
		print(Thread.current)
		defer {
			print("Task \(taskID) has been cancelled.")
		}
		while !Task.isCancelled {
			try? await Task.sleep(nanoseconds: 1000000000)
			let now = Date.now
			date = now
			print("Task ID \(taskID) :\(now.formatted(date: .numeric, time: .complete))")
		}
	}
}

#Preview {
	TaskDemo4WithExecutionTaskInNotMainActor()
}
