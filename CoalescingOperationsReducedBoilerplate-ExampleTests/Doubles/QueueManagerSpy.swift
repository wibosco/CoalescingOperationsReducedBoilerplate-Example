//
//  QueueManagerSpy.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

class QueueManagerSpy: QueueManager {
    
    var enqueuedOperation: Operation!
    var numberOfTimesEnqueuedWasCalled = 0
    
    // MARK: - Overrides
    
    override func enqueue(operation: Operation) {
        enqueuedOperation = operation
        
        numberOfTimesEnqueuedWasCalled += 1
    }
}
