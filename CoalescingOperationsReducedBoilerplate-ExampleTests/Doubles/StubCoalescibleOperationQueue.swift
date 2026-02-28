//
//  StubCoalescibleOperationQueue.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

final class StubCoalescibleOperationQueue: CoalescibleOperationQueue {
    enum Event: Equatable {
        case addOperation(Operation)
    }
    
    private(set) var events: [Event] = []
    
    var operations = [Operation]()
    
    func addOperation(_ op: Operation) {
        events.append(.addOperation(op))
    }
}
