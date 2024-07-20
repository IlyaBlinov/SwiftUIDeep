//
//  TaskDemo2.swift
//  SwiftUIDeep
//
//  Created by Илья Блинов on 19.07.2024.
//

// https://fatbobman.com/en/posts/mastering_swiftui_task_modifier/#task-vs-onreceive

import SwiftUI

struct TaskDemo2: View {
	
	@State var status: Status = .loading
	
	@State var reloadTrigger = false
	
	let url = URL(string: "https://source.unsplash.com/400x300")! // get random image url
	
	var body: some View {
		let _ = Self._printChanges()
		VStack {
			Group {
				switch status {
				case .loading:
					Rectangle()
						.fill(.secondary)
						.overlay(Text("Loading"))
				case .image(let image):
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
				case .error:
					Rectangle()
						.fill(.secondary)
						.overlay(Text("Failed to load image"))
				}
			}
			.padding()
			.frame(width: 400, height: 300)
			
			Button(status.loading ? "Loading" : "Reload") {
				reloadTrigger.toggle()  // load image
			}
			.disabled(status.loading)
			.buttonStyle(.bordered)
		}
		.animation(.easeInOut, value: status)
		.task(id: reloadTrigger) {
			do {
				status = .loading
				var bytes = [UInt8]()
				for try await byte in url.resourceBytes {
					bytes.append(byte)
				}
				if let uiImage = UIImage(data: Data(bytes)) {
					let image = Image(uiImage: uiImage)
					status = .image(image)
				} else {
					status = .error
				}
			} catch {
				status = .error
			}
		}
	}
	
	enum Status: Equatable {
		case loading
		case image(Image)
		case error
		
		var loading: Bool {
			switch self {
			case .loading:
				return true
			default:
				return false
			}
		}
	}
}

#Preview {
    TaskDemo2()
}
