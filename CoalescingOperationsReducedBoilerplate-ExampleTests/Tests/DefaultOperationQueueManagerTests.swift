//
//  QueueManagerTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 24/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation
import XCTest

@testable import CoalescingOperationsReducedBoilerplate_Example

final class DefaultOperationQueueManagerTests: XCTestCase {
    private var queue: StubCoalescibleOperationQueue!
    
    private var sut: DefaultOperationQueueManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queue = StubCoalescibleOperationQueue()
        sut = DefaultOperationQueueManager(queue: queue)
    }
    
    override func tearDown() {
        sut = nil
        queue = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Enqueue
    
    func test_givenEmptyQueue_whenEnqueued_thenOperationIsAddedToQueue() {
        let operation = StubCoalescibleOperation<String>()
        
        sut.enqueue(operation: operation)
        
        XCTAssertEqual(queue.events, [.addOperation(operation)])
    }
    
    func test_givenNoMatchingOperationOnQueue_whenEnqueued_thenOperationIsAddedToQueue() {
        let existingOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        queue.operations = [existingOperation]
        
        let newOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_B")
        
        sut.enqueue(operation: newOperation)
        
        XCTAssertEqual(queue.events, [.addOperation(newOperation)])
    }
    
    func test_givenMatchingOperationOnQueue_whenEnqueued_thenOperationIsNotAddedToQueue() {
        let existingOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        queue.operations = [existingOperation]
        
        let newOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        
        sut.enqueue(operation: newOperation)
        
        XCTAssertTrue(queue.events.isEmpty)
    }
    
    func test_givenMatchingOperationOnQueue_whenEnqueued_thenExistingOperationIsCoalescedWithNewOperation() {
        let existingOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        queue.operations = [existingOperation]
        
        let newOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        
        sut.enqueue(operation: newOperation)
        
        XCTAssertEqual(existingOperation.events.count, 1)
        
        guard case .coalesce(let coalescedOperation) = existingOperation.events.first else {
            XCTFail("Expected coalesce event")
            return
        }
        
        XCTAssertTrue(coalescedOperation.unwrap() === newOperation)
    }
    
    func test_givenMultipleMatchingOperations_whenEnqueued_thenFirstMatchIsCoalesced() {
        let existingOperation1 = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        let existingOperation2 = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        queue.operations = [existingOperation1, existingOperation2]
        
        let newOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        
        sut.enqueue(operation: newOperation)
        
        XCTAssertEqual(existingOperation1.events.count, 1)
        XCTAssertTrue(existingOperation2.events.isEmpty)
    }
    
    func test_givenMatchingOperationWithDifferentType_whenEnqueued_thenNewOperationIsAddedToQueue() {
        let existingOperation = StubCoalescibleOperation<Int>(identifier: "test_identifier_A")
        queue.operations = [existingOperation]
        
        let newOperation = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        
        sut.enqueue(operation: newOperation)
        
        XCTAssertEqual(queue.events, [.addOperation(newOperation)])
        XCTAssertTrue(existingOperation.events.isEmpty)
    }
    
    func test_givenMultipleNonMatchingOperations_whenEnqueued_thenAllAreAddedToQueue() {
        let operation1 = StubCoalescibleOperation<String>(identifier: "test_identifier_A")
        let operation2 = StubCoalescibleOperation<String>(identifier: "test_identifier_B")
        let operation3 = StubCoalescibleOperation<String>(identifier: "test_identifier_C")
        
        sut.enqueue(operation: operation1)
        sut.enqueue(operation: operation2)
        sut.enqueue(operation: operation3)
        
        XCTAssertEqual(queue.events, [
            .addOperation(operation1),
            .addOperation(operation2),
            .addOperation(operation3)
        ])
    }
}
