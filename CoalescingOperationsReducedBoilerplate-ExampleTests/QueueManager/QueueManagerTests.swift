//
//  QueueManagerTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 24/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class CoalescibleOperationSpy: CoalescibleOperation {
    
    // MARK: Properties
    
    var coalesceAttempted = false
    var coalesceAttemptedOnOperation: CoalescibleOperation!
    
    // MARK: Init
    
    override init() {
        super.init()
        self.identifier = "coalescibleOperationSpy"
    }
    
    // MARK: Coalesce
    
    override func coalesce(operation: CoalescibleOperation) {
        coalesceAttempted = true
        coalesceAttemptedOnOperation = operation
    }
}

class QueueManagerTests: XCTestCase {
    
    // MARK: - Accessors
    
    var queueManager: QueueManager!
    
    // MARK: Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = QueueManager()
        queueManager.queue.suspended = true
    }
    
    // MARK: - Tests
    
    // MARK: Enqueue
    
    func test_enqueue_count() {
        let operationA = NSOperation()
        
        queueManager.enqueue(operationA)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_nonCoalescibleOperations() {
        let operationA = NSOperation()
        let operationB = NSOperation()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    func test_enqueue_coalescibleOperations() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_coalesceOfOperationsAttempted() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertTrue(operationA.coalesceAttempted)
    }
    
    func test_enqueue_coalesceOfOperationsAttemptedInOrder() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operationA)
        queueManager.enqueue(operationB)
        
        XCTAssertEqual(operationB, operationA.coalesceAttemptedOnOperation)
    }
    
    // MARK: Existing
    
    func test_existingCoalescibleOperationOnQueue_noMatch() {
        let operation = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation)
        
        XCTAssertNil(queueManager.existingCoalescibleOperationOnQueue("nonMatchIdentifier"))
    }
    
    func test_existingCoalescibleOperationOnQueue_match() {
        let operation = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation)
        
        XCTAssertNotNil(queueManager.existingCoalescibleOperationOnQueue(operation.identifier))
    }
}
