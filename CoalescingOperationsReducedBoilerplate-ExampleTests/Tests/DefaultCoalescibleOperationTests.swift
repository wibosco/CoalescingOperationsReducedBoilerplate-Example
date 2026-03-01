//
//  DefaultCoalescibleOperationTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 04/09/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation
import XCTest

@testable import CoalescingOperationsReducedBoilerplate_Example

final class DefaultCoalescibleOperationTests: XCTestCase {
    // MARK: - Tests
    
    // MARK: Init
    
    func test_givenIdentifierAndCompletionHandler_whenCreated_thenPropertiesAreSet() {
        let queue = OperationQueue()
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                            callBackQueue: queue) { _ in }
        
        XCTAssertEqual(operation.identifier, "test_identifier")
        XCTAssertTrue(operation.callBackQueue === queue)
    }
    
    // MARK: State
    
    func test_givenNewOperation_whenCreated_thenIsReady() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        XCTAssertTrue(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
        XCTAssertFalse(operation.isCancelled)
    }
    
    func test_givenOperationStarted_whenStarted_thenIsExecuting() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        operation.start()
        
        XCTAssertFalse(operation.isReady)
        XCTAssertTrue(operation.isExecuting)
        XCTAssertFalse(operation.isFinished)
        XCTAssertFalse(operation.isCancelled)
    }
    
    func test_givenOperationStarted_whenCompleted_thenIsExecuting() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        operation.start()
        operation.complete(result: .success(true))
        
        XCTAssertFalse(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertTrue(operation.isFinished)
        XCTAssertFalse(operation.isCancelled)
    }
    
    func test_givenOperationStarted_whenCancelled_thenIsCancelled() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        operation.start()
        operation.cancel()
        
        XCTAssertFalse(operation.isReady)
        XCTAssertFalse(operation.isExecuting)
        XCTAssertTrue(operation.isFinished)
        XCTAssertTrue(operation.isCancelled)
    }
    
    func test_isAsynchronous_givenOperation_thenReturnsTrue() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        XCTAssertTrue(operation.isAsynchronous)
    }
    
    // MARK: Complete
    
    func test_givenSuccessResult_whenCompleted_thenCompletionHandlerCalledWithSuccess() {
        let callBackQueue = OperationQueue()
        
        let expectation = expectation(description: "completion called")
        
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                            callBackQueue: callBackQueue) { result in
            do {
                let val = try result.get()
                XCTAssertTrue(val)
            } catch {
                XCTFail("Unexpected error thrown")
            }
            
            expectation.fulfill()
        }
        
        operation.start()
        operation.complete(result: .success(true))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_givenFailureResult_whenCompleted_thenCompletionHandlerCalledWithFailure() {
        let callBackQueue = OperationQueue()
        
        let expectation = expectation(description: "completion called")
        
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                            callBackQueue: callBackQueue) { result in
            do {
                _ = try result.get()
                XCTFail("Expected to throw error")
            } catch {
                XCTAssertEqual((error as? TestError), .test)
            }
            
            expectation.fulfill()
        }
        
        operation.start()
        operation.complete(result: .failure(TestError.test))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_givenOperationCancelled_whenCompleted_thenCompletionHandlerNotCalled() {
        let callBackQueue = OperationQueue()
        
        let expectation = expectation(description: "completion called")
        expectation.isInverted = true
        
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                            callBackQueue: callBackQueue) { _ in
            expectation.fulfill()
        }
        
        operation.start()
        operation.cancel()
        operation.complete(result: .success(true))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_givenNonCoalscedOperation_whenCompleted_thenCompletionHandlerCalledOnCorrectQueue() {
        let callBackQueue = OperationQueue()
        callBackQueue.name = "test.callback.queue"
        
        let expectation = expectation(description: "completion called")
        
        let operation = DefaultCoalescibleOperation<String>(identifier: "test",
                                                            callBackQueue: callBackQueue) { _ in
            XCTAssertEqual(OperationQueue.current?.name, callBackQueue.name)
            
            expectation.fulfill()
        }
        
        operation.start()
        operation.complete(result: .success("hello"))
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: Cancel
    
    func test_givenExecutingOperation_whenCancelled_thenTransitionsToFinished() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        operation.start()
        
        XCTAssertTrue(operation.isExecuting)
        
        operation.cancel()
        
        XCTAssertTrue(operation.isCancelled)
        XCTAssertTrue(operation.isFinished)
        XCTAssertFalse(operation.isExecuting)
    }
    
    func test_givenCancelledOperation_whenStarted_thenOperationAborted() {
        let operation = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier") { _ in }
        
        operation.cancel()
        
        XCTAssertTrue(operation.isCancelled)
        
        operation.start()
        
        XCTAssertTrue(operation.isCancelled)
        XCTAssertTrue(operation.isFinished)
        XCTAssertFalse(operation.isExecuting)
    }
    
    // MARK: Coalesce
    
    func test_givenTwoCoalscedOperations_whenSuccessResult_thenAllCompletionHandlersCalled() {
        let callBackQueue = OperationQueue()
        
        let expectation1 = expectation(description: "first completion called")
        let expectation2 = expectation(description: "second completion called")
        
        let operation1 = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                             callBackQueue: callBackQueue) { result in
            do {
                let val = try result.get()
                XCTAssertTrue(val)
            } catch {
                XCTFail("Unexpected error thrown")
            }
            
            expectation1.fulfill()
        }
        
        let operation2 = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                             callBackQueue: callBackQueue) { result in
            do {
                let val = try result.get()
                XCTAssertTrue(val)
            } catch {
                XCTFail("Unexpected error thrown")
            }
            
            expectation2.fulfill()
        }
        
        operation1.coalesce(operation: AnyCoalescibleOperation(operation2))
        
        operation1.start()
        operation1.complete(result: .success(true))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_givenTwoCoalscedOperations_whenFailureResult_thenAllCompletionHandlersReceiveFailure() {
        let callBackQueue = OperationQueue()
        
        let expectation1 = expectation(description: "first completion called")
        let expectation2 = expectation(description: "second completion called")
        
        let operation1 = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                           callBackQueue: callBackQueue) { result in
            do {
                _ = try result.get()
                XCTFail("Expected to throw error")
            } catch {
                XCTAssertEqual((error as? TestError), .test)
            }
            
            expectation1.fulfill()
        }
        
        let operation2 = DefaultCoalescibleOperation<Bool>(identifier: "test_identifier",
                                                           callBackQueue: callBackQueue) { result in
            do {
                _ = try result.get()
                XCTFail("Expected to throw error")
            } catch {
                XCTAssertEqual((error as? TestError), .test)
            }
            
            expectation2.fulfill()
        }
        
        operation1.coalesce(operation: AnyCoalescibleOperation(operation2))
        
        operation1.start()
        operation1.complete(result: .failure(TestError.test))
        
        waitForExpectations(timeout: 1)
    }

    func test_givenCoalscedOperationsWithDifferentCallBackQueues_whenCompleted_thenCompletionHandlersCalledOnOriginalQueues() {
        let callBackQueue1 = OperationQueue()
        callBackQueue1.name = "test.callback.queue1"
        
        let callBackQueue2 = OperationQueue()
        callBackQueue2.name = "test.callback.queue2"
        
        let expectation1 = expectation(description: "first completion called")
        let expectation2 = expectation(description: "second completion called")
        
        let operation1 = DefaultCoalescibleOperation<String>(identifier: "test",
                                                             callBackQueue: callBackQueue1) { _ in
            XCTAssertEqual(OperationQueue.current?.name, callBackQueue1.name)
            
            expectation1.fulfill()
        }
        
        let operation2 = DefaultCoalescibleOperation<String>(identifier: "test",
                                                             callBackQueue: callBackQueue2) { _ in
            XCTAssertEqual(OperationQueue.current?.name, callBackQueue2.name)
            
            expectation2.fulfill()
        }
        
        operation1.coalesce(operation: AnyCoalescibleOperation(operation2))
        
        operation1.start()
        operation1.complete(result: .success("shared"))
        
        waitForExpectations(timeout: 1)
    }
}
