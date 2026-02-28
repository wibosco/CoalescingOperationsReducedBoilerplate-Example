//
//  CoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 30/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class CoalescibleOperation: Operation {
    
    typealias CompletionClosure = (_ successful: Bool) -> Void
    
    // MARK: - Accessors
    
    //Should be set by subclass
    var identifier: String!
    
    var completion: (CompletionClosure)?
    private(set) var callBackQueue: OperationQueue
    
    // MARK: - Init
    
    override init() {
        self.callBackQueue = OperationQueue.current!
        
        super.init()
    }
    
    // MARK: - AsynchronousSupport
    
    private var _executing: Bool = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func start() {
        if isCancelled {
            finish()
            return
        } else {
            _executing = true;
            _finished = false;
        }
    }
    
    private func finish() {
        _executing = false
        _finished = true
    }
    
    // MARK: - Coalesce
    
    func coalesce(operation: CoalescibleOperation) {
        let initalCompletionClosure = self.completion
        let additionalCompletionClosure = operation.completion
        
        self.completion = {(successful) in

            if let initalCompletionClosure = initalCompletionClosure {
                initalCompletionClosure(successful)
            }
            
            if let additionalCompletionClosure = additionalCompletionClosure {
                additionalCompletionClosure(successful)
            }
        }
    }
    
    // MARK: - Completion
    
    func didComplete() {
        finish()
        
        callBackQueue.addOperation {
            if let completion = self.completion {
                completion(true)
            }
        }
    }
}
