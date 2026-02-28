//
//  CoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 30/08/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

protocol CoalescibleOperation<T> {
    associatedtype T

    var identifier: String { get }
    var completionHandler: (_ result: Result<T, Error>) -> Void { get }
    var callBackQueue: OperationQueue { get }
    
    func complete(result: Result<T, Error>)
    func coalesce(operation: any CoalescibleOperation<T>)
}

class DefaultCoalescibleOperation<T>: Operation, CoalescibleOperation, @unchecked Sendable {
    let identifier: String
    private(set) var completionHandler: (_ result: Result<T, Error>) -> Void
    let callBackQueue: OperationQueue
    
    // MARK: - Init
    
    init(identifier: String,
         callBackQueue: OperationQueue = OperationQueue.current ?? .main,
         completionHandler: @escaping (_ result: Result<T, Error>) -> Void) {
        self.identifier = identifier
        self.callBackQueue = callBackQueue
        self.completionHandler = { result in
            callBackQueue.addOperation {
                completionHandler(result)
            }
        }
        
        super.init()
    }
    
    // MARK: - State
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    private func finish() {
        state = .finished
    }
    
    func complete(result: Result<T, Error>) {
        finish()
    
        if !isCancelled {
            completionHandler(result)
        }
    }
    
    override func cancel() {
        super.cancel()
        
        finish()
    }
    
    // MARK: - Coalesce
    
    func coalesce(operation: any CoalescibleOperation<T>) {
        let initialCompletionClosure = self.completionHandler
        let initialCallBackQueue = self.callBackQueue
        let additionalCompletionClosure = operation.completionHandler
        let additionalCallBackQueue = operation.callBackQueue
        
        self.completionHandler = { result in
            initialCallBackQueue.addOperation {
                initialCompletionClosure(result)
            }
            additionalCallBackQueue.addOperation {
                additionalCompletionClosure(result)
            }
        }
    }
}
