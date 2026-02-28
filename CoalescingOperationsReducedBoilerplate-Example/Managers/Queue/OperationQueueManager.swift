//
//  QueueManager.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

protocol CoalescibleOperationQueue {
    var operations: [Operation] { get }
    
    func addOperation(_ op: Operation)
}

extension OperationQueue: CoalescibleOperationQueue { }

protocol OperationQueueManager {
    func enqueue<T: Operation & CoalescibleOperation>(operation: T)
}

final class DefaultOperationQueueManager: OperationQueueManager {
    private let queue: CoalescibleOperationQueue
    
    // MARK: - Init
    
    init(queue: CoalescibleOperationQueue) {
        self.queue = queue
    }
    
    // MARK: - Enqueue
    
    func enqueue<T: Operation & CoalescibleOperation>(operation: T) {
        guard let existingCoalescibleOperation = existingCoalescibleOperationOnQueue(operation: operation) else {
            queue.addOperation(operation)
                
            return
        }
        
        existingCoalescibleOperation.coalesce(operation: operation)
    }
    
    private func existingCoalescibleOperationOnQueue<T>(operation: some CoalescibleOperation<T>) -> (any CoalescibleOperation<T>)? {
        queue.operations
            .lazy
            .compactMap { $0 as? (any CoalescibleOperation<T>) }
            .first { $0.identifier == operation.identifier }
    }
}
