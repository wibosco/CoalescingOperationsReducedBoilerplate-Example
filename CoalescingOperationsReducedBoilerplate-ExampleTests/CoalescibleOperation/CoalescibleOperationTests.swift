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
        let expectation = expectationWithDescription("Closure called")
        let operation = CoalescibleOperation()
        operation.completion = {(successful) in
            operationCalledBack = true
            expectation.fulfill()
        }
        
        operation.didComplete()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(operationCalledBack)
        }
    }
    
    func test_didComplete_callBackOnThreadItWasQueuedOn() {
        var callBackOnThreadA: NSOperationQueue!
        let expectationA = expectationWithDescription("Closure called")
        
        let queue = NSOperationQueue()
        queue.addOperationWithBlock {
            let operationA = CoalescibleOperation()
            operationA.completion = {(successful) in
                callBackOnThreadA = NSOperationQueue.currentQueue()!
                expectationA.fulfill()
            }
            
            operationA.didComplete()
        }
        
        
        var callBackOnThreadB: NSOperationQueue!
        let expectationB = expectationWithDescription("Closure called")
        
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            callBackOnThreadB = NSOperationQueue.currentQueue()!
            expectationB.fulfill()
        }
        
        operationB.didComplete()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertEqual(callBackOnThreadA, queue)
            XCTAssertNotEqual(callBackOnThreadA, NSOperationQueue.mainQueue())
            
            XCTAssertEqual(callBackOnThreadB, NSOperationQueue.mainQueue())
        }
    }
    
    func test_didComplete_completedOperationLeavesQueue() {
        let expectation = expectationWithDescription("Operation removed from queue on completion")
        let operation = TestCoalescingOperation()
        operation.completion = {(successful) in
            expectation.fulfill()
        }
        
        let queue = NSOperationQueue()
        queue.addOperation(operation)
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertEqual(0, queue.operations.count)
        }
    }
    
    // MARK: Coalesce
    
    func test_coalesce_mutlipleClosuresCalled() {
        var operationACalledBack = false
        let expectationA = expectationWithDescription("First callback called")
        let operationA = CoalescibleOperation()
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        var operationBCalledBack = false
        let expectationB = expectationWithDescription("Second callback called")
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operationB)
        operationA.didComplete()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(operationACalledBack)
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_secondClosuresCalledWhenFirstIsNotSet() {
        let operationA = CoalescibleOperation()
        
        var operationBCalledBack = false
        let expectationB = expectationWithDescription("Second callback called")
        let operationB = CoalescibleOperation()
        operationB.completion = {(successful) in
            operationBCalledBack = true
            expectationB.fulfill()
        }
        
        operationA.coalesce(operationB)
        operationA.didComplete()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(operationBCalledBack)
        }
    }
    
    func test_coalesce_firstClosuresCalledWhenSecondIsNotSet() {
        var operationACalledBack = false
        let expectationA = expectationWithDescription("First callback called")
        let operationA = CoalescibleOperation()
        operationA.completion = {(successful) in
            operationACalledBack = true
            expectationA.fulfill()
        }
        
        let operationB = CoalescibleOperation()
        
        operationA.coalesce(operationB)
        operationA.didComplete()
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertTrue(operationACalledBack)
        }
    }
}
