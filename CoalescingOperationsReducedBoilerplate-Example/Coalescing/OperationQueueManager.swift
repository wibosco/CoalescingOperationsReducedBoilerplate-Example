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
        if let matchingOperation = matchingCoalescibleOperation(for: operation) {
            if matchingOperation.coalesce(operation: AnyCoalescibleOperation(operation)) {
                return
            }
        }
        
        queue.addOperation(operation)
    }
    
    private func matchingCoalescibleOperation<T: CoalescibleOperation>(for operation: T) -> AnyCoalescibleOperation<T.Value>? {
        let existingOperation = queue.operations
            .lazy
            .compactMap { ($0 as? AnyCoalescibleOperationConvertible)?.eraseToAnyCoalescibleOperation() as AnyCoalescibleOperation<T.Value>? }
            .first { $0.identifier == operation.identifier }
    
        return existingOperation
    }
}
