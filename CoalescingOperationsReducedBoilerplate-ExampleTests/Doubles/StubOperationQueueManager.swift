//
//  StubOperationQueueManager.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

class StubOperationQueueManager: OperationQueueManager {
    enum Event: Equatable {
        case enqueue(Operation)
    }
    
    private(set) var events: [Event] = []
    
    func enqueue(operation: Operation) {
        events.append(.enqueue(operation))
    }
    
    func enqueue<T: Operation & CoalescibleOperation>(operation: T) {
        events.append(.enqueue(operation))
    }
}
