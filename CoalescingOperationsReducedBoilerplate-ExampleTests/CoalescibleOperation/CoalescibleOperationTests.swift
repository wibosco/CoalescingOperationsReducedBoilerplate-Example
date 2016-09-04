//
//  CoalescibleOperationTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 04/09/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

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
        var callBackOnThread: NSOperationQueue!
        let expectation = expectationWithDescription("Closure called")
        
        let queue = NSOperationQueue()
        queue.addOperationWithBlock {
            let operation = CoalescibleOperation()
            operation.completion = {(successful) in
                callBackOnThread = NSOperationQueue.currentQueue()!
                expectation.fulfill()
            }
            
            operation.didComplete()
        }
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertEqual(callBackOnThread, queue)
            XCTAssertNotEqual(callBackOnThread, NSOperationQueue.mainQueue())
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
