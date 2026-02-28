//
//  TestCoalescingOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 28/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

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
