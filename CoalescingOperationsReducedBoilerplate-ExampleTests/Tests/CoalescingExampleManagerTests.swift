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
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)

        XCTAssertEqual(2, queueManager.numberOfTimesEnqueuedWasCalled)
    }
    
    func test_addExampleCoalescingOperation_typeOfOperation() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager, completion: nil)
        
        XCTAssertTrue(queueManager.enqueuedOperation.isKind(of: CoalescingExampleOperation.self))
    }
    
    func test_addExampleCoalescingOperation_completionSet() {
        CoalescingExampleManager.addExampleCoalescingOperation(queueManager: queueManager) { (successful) in
            
        }
        
        let coalescibleOperation = queueManager.enqueuedOperation as! CoalescingExampleOperation
        
        XCTAssertNotNil(coalescibleOperation.completion)
    }
}
