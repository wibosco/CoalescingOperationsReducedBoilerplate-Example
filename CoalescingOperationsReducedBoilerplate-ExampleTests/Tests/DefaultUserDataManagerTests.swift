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

final class DefaultUserDataManagerTests: XCTestCase {
    private var queueManager: StubOperationQueueManager!
    private var factory: StubOperationFactory!
    
    private var sut: DefaultUserDataManager!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        queueManager = StubOperationQueueManager()
        factory = StubOperationFactory(operation: UserFetchOperation { _ in })
        
        sut = DefaultUserDataManager(queueManager: queueManager,
                                              factory: factory)
    }
    
    override func tearDown() {
        sut = nil
        factory = nil
        queueManager = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Add
    
    func test_addExampleCoalescingOperation_thenFactoryIsAskedToCreateOperation() {
        sut.fetchUser { _ in }
        
        XCTAssertEqual(factory.events.count, 1)
        
        guard case .createExampleOperation = factory.events.first else {
            XCTFail("Expected createExampleOperation event")
            return
        }
    }
    
    func test_addExampleCoalescingOperation_thenOperationFromFactoryIsEnqueued() {
        let expectedOperation = UserFetchOperation { _ in }
        factory.operation = expectedOperation
        
        sut.fetchUser { _ in }
        
        XCTAssertEqual(queueManager.events, [.enqueue(expectedOperation)])
    }
    
    func test_addExampleCoalescingOperation_thenCompletionHandlerIsPassedToFactory() {
        var completionCalled = false
        
        sut.fetchUser { _ in
            completionCalled = true
        }
        
        guard case .createExampleOperation(let capturedHandler) = factory.events.first else {
            XCTFail("Expected createExampleOperation event")
            return
        }
        
        capturedHandler(.success(true))
        
        XCTAssertTrue(completionCalled)
    }
}
