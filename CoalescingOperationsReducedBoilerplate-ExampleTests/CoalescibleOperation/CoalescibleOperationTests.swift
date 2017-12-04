//
//  CoalescibleOperationTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 04/09/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

/**
 An example subclass of a coalescible operation.
 */
class TestCoalescingOperation: CoalescibleOperation {
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.identifier = "testCoalescingOperationExampleIdentifier"
    }
    
    // MARK: - Lifecycle
    
    override func start() {
        super.start()
        
        sleep(1)
        
        didComplete()
    }
}

class CoalescibleOperationTests: XCTestCase {
    
    // MARK: - Tests
    
    // MARK: DidComplete
    
    func test_didComplete_closuresCalled() {
        var operationCalledBack = false
        let anExpectation = expectation(description: "Closure called")
        let operation = CoalescibleOperation()
        operation.completion = {(successful) in
            operationCalledBack = true
            anExpectation.fulfill()
        }
        
        operation.didComplete()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationCalledBack)
        }
    }
    
    func test_didComplete_callBackOnThreadItWasQueuedOn() {
        var callBackOnThreadA: OperationQueue!
        let expectationA = expectation(description: "Closure called")
        
        let queue = OperationQueue()
        queue.addOperation {
            let operationA = CoalescibleOperation()
            operationA.completion = {(successful) in
                callBackOnThreadA = OperationQueue.current!
                expectationA.fulfill()
            }
            
            operationA.didComplete()
        }
        
        
        var callBackOnThreadB: OperationQueue!
        let expectationB = expectation(description: "Closure called")
        
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            callBackOnThreadB = OperationQueue.current!
            expectationB.fulfill()
        }
        
        operationB.didComplete()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(callBackOnThreadA, queue)
            XCTAssertNotEqual(callBackOnThreadA, OperationQueue.main)
            
            XCTAssertEqual(callBackOnThreadB, OperationQueue.main)
        }
    }
    
    func test_didComplete_completedOperationLeavesQueue() {
        let anExpectation = expectation(description: "Operation removed from queue on completion")
        let operation = TestCoalescingOperation()
        operation.completion = {(successful) in
            anExpectation.fulfill()
        }
        
        let queue = OperationQueue()
        queue.addOperation(operation)
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertEqual(0, queue.operations.count)
        }
    }
    
    // MARK: Coalesce
    
    func test_coalesce_mutlipleClosuresCalled() {
        var operationACalledBack = false
        let expectationA = expectation(description: "First callback called")
        let operationA = CoalescibleOperation()
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        var operationBCalledBack = false
        let expectationB = expectation(description: "Second callback called")
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operation: operationB)
        operationA.didComplete()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationACalledBack)
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_secondClosuresCalledWhenFirstIsNotSet() {
        let operationA = CoalescibleOperation()
        
        var operationBCalledBack = false
        let expectationB = expectation(description: "Second callback called")
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operation: operationB)
        operationA.didComplete()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_firstClosuresCalledWhenSecondIsNotSet() {
        var operationACalledBack = false
        let expectationA = expectation(description: "First callback called")
        let operationA = CoalescibleOperation()
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        let operationB = CoalescibleOperation()
        
        operationA.coalesce(operation: operationB)
        operationA.didComplete()
        
        waitForExpectations(timeout: 2) { (error) in
            XCTAssertTrue(operationACalledBack)
        }
    }
}
