//
//  Mock.swift
//  SwiftUIDeep_Tests
//
//  Created by Илья Блинов on 03.08.2024.
//

import Foundation

@testable import SwiftUIDeep

class EmailServiceMock: EmailService {
	
	private var emailServiceWasCalled: Bool = false
	private var emailsSentCount = 0
	
	func sendEmail(to mail: String, subject: String) {
		emailServiceWasCalled = true
		emailsSentCount += 1
	}
	
	func verify() -> Bool {
		emailServiceWasCalled && emailsSentCount == 1
	}
}
