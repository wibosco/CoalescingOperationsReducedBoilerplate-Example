//
//  CoalescibleOperationSpy.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

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
