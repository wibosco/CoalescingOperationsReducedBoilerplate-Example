//
//  CoalescingExampleManager.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/**
 An example manager that handles queuing operations.

 It exists as we don't really want our VCs to know anything about the queue.
 */
class CoalescingExampleManager: NSObject {
    
    // MARK: - Add
    
    class func addExampleCoalescingOperation(queueManager: QueueManager = QueueManager.sharedInstance, completion: (CoalescibleOperation.CompletionClosure)?) {
        let operation = CoalescingExampleOperation()
        operation.completion = completion
        queueManager.enqueue(operation)
    }
}
