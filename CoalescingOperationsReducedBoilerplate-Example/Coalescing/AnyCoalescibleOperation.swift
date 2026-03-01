//
//  AnyCoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 01/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

struct AnyCoalescibleOperation<Value> {
    var identifier: String { _identifier() }
    var completionHandler: (_ result: Result<Value, Error>) -> Void { _completionHandler() }
    var callBackQueue: OperationQueue { _callBackQueue() }
    
    private let _identifier: () -> String
    private let _completionHandler: () -> ((_ result: Result<Value, Error>) -> Void)
    private let _callBackQueue: () -> OperationQueue
    private let _finish: (Result<Value, Error>) -> Void
    private let _coalesce: (AnyCoalescibleOperation<Value>) -> Void
    private let _unwrap: () -> AnyObject
    
    // MARK: - Init
    
    init<ConcreteOperation: CoalescibleOperation>(_ concrete: ConcreteOperation) where ConcreteOperation.Value == Value {
        _identifier = { concrete.identifier }
        _completionHandler = { concrete.completionHandler }
        _callBackQueue = { concrete.callBackQueue }
        _finish = { concrete.finish(result: $0) }
        _coalesce = { concrete.coalesce(operation: $0) }
        _unwrap = { concrete as AnyObject }
    }
    
    // MARK: - Actions
    
    func finish(result: Result<Value, Error>) {
        _finish(result)
    }
    
    func coalesce(operation: AnyCoalescibleOperation<Value>) {
        _coalesce(operation)
    }
    
    func unwrap() -> AnyObject {
        _unwrap()
    }
}
