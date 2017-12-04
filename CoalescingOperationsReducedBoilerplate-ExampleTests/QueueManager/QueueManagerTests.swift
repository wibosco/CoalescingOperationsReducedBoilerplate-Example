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
        queueManager.queue.isSuspended = true
    }
    
    // MARK: - Tests
    
    // MARK: Enqueue
    
    func test_enqueue_count() {
        let operationA = Operation()
        
        queueManager.enqueue(operation: operationA)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_nonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = Operation()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    func test_enqueue_coalescibleOperations() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 1)
    }
    
    func test_enqueue_coalesceOfOperationsAttempted() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertTrue(operationA.coalesceAttempted)
    }
    
    func test_enqueue_coalesceOfOperationsAttemptedInOrder() {
        let operationA = CoalescibleOperationSpy()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertEqual(operationB, operationA.coalesceAttemptedOnOperation)
    }
    
    func test_enqueue_CoalescibleAndNonCoalescibleOperations() {
        let operationA = CoalescibleOperationSpy()
        let operationB = Operation()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertEqual(queueManager.queue.operationCount, 2)
    }
    
    // MARK: Existing
    
    func test_existingCoalescibleOperationOnQueue_noMatch() {
        let operation = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operation)
        
        XCTAssertNil(queueManager.existingCoalescibleOperationOnQueue(identifier: "nonMatchIdentifier"))
    }
    
    func test_existingCoalescibleOperationOnQueue_match() {
        let operation = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operation)
        
        XCTAssertNotNil(queueManager.existingCoalescibleOperationOnQueue(identifier: operation.identifier))
    }
    
    func test_existingCoalescibleOperationOnQueue_matchWithCombinationOfCoalescibleAndNonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertNotNil(queueManager.existingCoalescibleOperationOnQueue(identifier: operationB.identifier))
    }
    
    func test_existingCoalescibleOperationOnQueue_noMatchWithCombinationOfCoalescibleAndNonCoalescibleOperations() {
        let operationA = Operation()
        let operationB = CoalescibleOperationSpy()
        
        queueManager.enqueue(operation: operationA)
        queueManager.enqueue(operation: operationB)
        
        XCTAssertNil(queueManager.existingCoalescibleOperationOnQueue(identifier: "nonMatchIdentifier"))
    }
}
