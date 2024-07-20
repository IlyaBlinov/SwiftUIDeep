//
//  TimerTaskDemo.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 20.07.2024.
//
// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive
import SwiftUI

struct TaskDemo3WithCancellation: View {
	
	@State var date = Date.now
	@State var show = true
	
	var body: some View {
		let _ = Self._printChanges()
		VStack {
			Button(show ? "Hide Timer" : "Show Timer") {
				show.toggle()
			}
			if show {
				Text(date,format: .dateTime.hour().minute().second())
					.task {
						// When a @Sendable async closure is marked with the @_inheritActorContext attribute, the closure will inherit the actor context (i.e. which actor it should run on, in body used MainA Actor) based on its declaration location. Closures that do not have a specific requirement to run on a particular actor can run anywhere (i.e. on any thread).
						// Swift uses a cooperative task cancellation mechanism, which means that SwiftUI cannot directly stop the asynchronous task created by the task modifier. When the conditions for stopping the asynchronous task created by the task modifier are met, SwiftUI will send a task cancellation signal to the task, and the task must respond to the signal and stop the operation on its own.
						// SwiftUI will send a task cancellation signal to the asynchronous task created by the task modifier in the following two cases:
						// When the view (the view bound by the task modifier) meets the onDisappear trigger condition
						// When the bound value changes (using task to observe value changes)
						print(Thread.current)
						let taskID = UUID()  // task ID
						while !Task.isCancelled { // while true to while !Task.isCancelled
							try? await Task.sleep(nanoseconds: 1_000_000_000)
							let now = Date.now
							date = now
							print("Task ID \(taskID) :\(now.formatted(date: .numeric, time: .complete))")
						}
					}
			}
		}
	}
}


#Preview {
	TaskDemo3WithCancellation()
}
