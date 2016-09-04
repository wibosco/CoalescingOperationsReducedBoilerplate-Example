//
//  CoalescingManagerTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class QueueManagerSpy: QueueManager {
    
    var enqueuedOperation: NSOperation!
    var numberOfTimesEnqueuedWasCalled = 0
    
    // MARK: - Overrides
    
    override func enqueue(operation: NSOperation) {
        enqueuedOperation = operation
        
        numberOfTimesEnqueuedWasCalled += 1
    }
}
//
class CoalescingManagerTests: XCTestCase {

    // MARK: - Accessors
    
    var queueManager: QueueManagerSpy!

    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManagerSpy()
    }

    // MARK: - Tests
    
    // MARK: Added
    
    func test_addExampleCoalescingOperation_multipleOperationsEnqueued() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)

        XCTAssertEqual(2, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_typeOfOperation() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager, completion: nil)
        
        XCTAssertTrue(queueManager.enqueuedOperation.isKindOfClass(CoalescingExampleOperation))
    }
    
    func test_addExampleCoalescingOperation_completionSet() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager) { (successful) in
            
        }
        
        let coalescibleOperation = queueManager.enqueuedOperation as! CoalescingExampleOperation
        
        XCTAssertNotNil(coalescibleOperation.completion)
    }
}
