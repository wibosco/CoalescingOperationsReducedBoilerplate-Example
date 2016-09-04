//
//  CoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 30/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class CoalescibleOperation: NSOperation {

    typealias CompletionClosure = (successful: Bool) -> Void
    
    // MARK: Accessors
    
    //Should be set by subclass
    var identifier: String!
    
    var completion: (CompletionClosure)?
    private(set) var callBackQueue: NSOperationQueue
    
    // MARK: Init
    
    override init() {
        self.callBackQueue = NSOperationQueue.currentQueue()!
        
        super.init()
    }
    
    // MARK:
    
    override var asynchronous: Bool {
        return true
    }
    
    // MARK: - Coalesce
    
    func coalesce(operation: CoalescibleOperation) {
        // Completion coalescing
        let initalCompletionClosure = self.completion
        let additionalCompletionClosure = operation.completion
        
        self.completion = {(successful) in
            if let initalCompletionClosure = initalCompletionClosure {
                initalCompletionClosure(successful: successful)
            }
            
            if let additionalCompletionClosure = additionalCompletionClosure {
                additionalCompletionClosure(successful: successful)
            }
        }
    }
    
    // MARK: - Completion
    
    func didComplete() {
        callBackQueue.addOperationWithBlock {
            if let completion = self.completion {
                completion(successful: true)
            }
        }
    }
}
