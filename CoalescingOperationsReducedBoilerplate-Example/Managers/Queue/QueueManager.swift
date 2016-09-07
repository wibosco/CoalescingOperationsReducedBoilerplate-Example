//
//  QueueManager.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class QueueManager: NSObject {
    
    // MARK: - Accessors
    
    lazy var queue: NSOperationQueue = {
        let queue = NSOperationQueue()
        
        return queue;
    }()
    
    // MARK: - SharedInstance
    
    static let sharedInstance = QueueManager()
    
    // MARK: - Addition
    
    func enqueue(operation: NSOperation) {
        if operation.isKindOfClass(CoalescibleOperation) {
            let coalescibleOperation = operation as! CoalescibleOperation
            
            if let existingCoalescibleOperation = existingCoalescibleOperationOnQueue(coalescibleOperation.identifier){
                existingCoalescibleOperation.coalesce(coalescibleOperation)
            } else {
                queue.addOperation(coalescibleOperation)
            }
            
        } else {
           queue.addOperation(operation)
        }
    }
    
    // MARK: - Existing
    
    func existingCoalescibleOperationOnQueue(identifier: String) -> CoalescibleOperation? {
        let operations = self.queue.operations
        let matchingOperations = (operations).filter({(operation) -> Bool in
            if operation.isKindOfClass(CoalescibleOperation) {
                let coalescibleOperation = operation as! CoalescibleOperation
                return identifier == coalescibleOperation.identifier
            }
            
            return false
        })
        
        return matchingOperations.first as? CoalescibleOperation
    }
}
