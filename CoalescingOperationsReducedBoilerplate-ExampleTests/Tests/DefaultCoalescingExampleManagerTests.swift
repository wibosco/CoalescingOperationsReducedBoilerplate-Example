//
//  CoalescingManagerTests.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 26/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation
import XCTest

@testable import CoalescingOperationsReducedBoilerplate_Example

final class DefaultCoalescingExampleManagerTests: XCTestCase {
    private var stubQueueManager: StubOperationQueueManager!
    private var stubFactory: StubCoalescingOperationFactory!
    private var sut: DefaultCoalescingExampleManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        stubQueueManager = StubOperationQueueManager()
        stubFactory = StubCoalescingOperationFactory(operation: StubCoalescibleOperation<Bool>())
        
        sut = DefaultCoalescingExampleManager(queueManager: stubQueueManager,
                                              factory: stubFactory)
    }
    
    override func tearDown() {
        sut = nil
        stubFactory = nil
        stubQueueManager = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Add
    
    func test_addExampleCoalescingOperation_thenFactoryIsAskedToCreateOperation() {
        sut.addExampleCoalescingOperation { _ in }
        
        XCTAssertEqual(stubFactory.events.count, 1)
        
        guard case .createExampleOperation = stubFactory.events.first else {
            XCTFail("Expected createExampleOperation event")
            return
        }
    }
    
    func test_addExampleCoalescingOperation_thenOperationFromFactoryIsEnqueued() {
        let expectedOperation = StubCoalescibleOperation<Bool>()
        stubFactory.operation = expectedOperation
        
        sut.addExampleCoalescingOperation { _ in }
        
        XCTAssertEqual(stubQueueManager.events, [.enqueue(expectedOperation)])
    }
    
    func test_addExampleCoalescingOperation_thenCompletionHandlerIsPassedToFactory() {
        var completionCalled = false
        
        sut.addExampleCoalescingOperation { _ in
            completionCalled = true
        }
        
        guard case .createExampleOperation(let capturedHandler) = stubFactory.events.first else {
            XCTFail("Expected createExampleOperation event")
            return
        }
        
        capturedHandler(.success(true))
        
        XCTAssertTrue(completionCalled)
    }
}
