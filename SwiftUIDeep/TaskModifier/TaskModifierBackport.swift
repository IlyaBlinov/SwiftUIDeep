//
//  TaskModifierBackport.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 20.07.2024.
//

// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive

#if canImport(_Concurrency)
import _Concurrency
import Foundation
import SwiftUI

public extension View {
	@available(iOS, introduced: 13.0, obsoleted: 15.0)
	func task(priority: TaskPriority = .userInitiated, @_inheritActorContext _ action: @escaping @Sendable () async -> Void) -> some View {
		modifier(_MyTaskModifier(priority: priority, action: action))
	}
	
	@available(iOS, introduced: 14.0, obsoleted: 15.0)
	func task<T>(id value: T, priority: TaskPriority = .userInitiated, @_inheritActorContext _ action: @escaping @Sendable () async -> Void) -> some View where T: Equatable {
		modifier(_MyTaskValueModifier(value: value, priority: priority, action: action))
	}
}

@available(iOS 13,*)
struct _MyTaskModifier: ViewModifier {
	@State private var currentTask: Task<Void, Never>?
	let priority: TaskPriority
	let action: @Sendable () async -> Void
	
	@inlinable public init(priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
		self.priority = priority
		self.action = action
	}
	
	public func body(content: Content) -> some View {
		content
			.onAppear {
				currentTask = Task(priority: priority, operation: action)
			}
			.onDisappear {
				currentTask?.cancel()
			}
	}
}

@available(iOS 13,*)
struct _MyTaskValueModifier<Value>: ViewModifier where Value: Equatable {
	var action: @Sendable () async -> Void
	var priority: TaskPriority
	var value: Value
	@State private var currentTask: Task<Void, Never>?
	
	public init(value: Value, priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
		self.action = action
		self.priority = priority
		self.value = value
	}
	
	public func body(content: Content) -> some View {
		content
			.onAppear {
				currentTask = Task(priority: priority, operation: action)
			}
			.onDisappear {
				currentTask?.cancel()
			}
			.onChange(of: value) { _ in
				currentTask?.cancel()
				currentTask = Task(priority: priority, operation: action)
			}
	}
}
#endif
