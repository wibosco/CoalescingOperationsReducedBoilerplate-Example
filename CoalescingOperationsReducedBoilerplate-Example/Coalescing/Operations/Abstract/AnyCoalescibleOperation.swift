//
//  AnyCoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 01/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

struct AnyCoalescibleOperation<T> {
    var identifier: String { _identifier() }
    var completionHandler: (_ result: Result<T, Error>) -> Void { _completionHandler() }
    var callBackQueue: OperationQueue { _callBackQueue() }
    
    private let _identifier: () -> String
    private let _completionHandler: () -> ((_ result: Result<T, Error>) -> Void)
    private let _callBackQueue: () -> OperationQueue
    private let _complete: (Result<T, Error>) -> Void
    private let _coalesce: (AnyCoalescibleOperation<T>) -> Void
    private let _unwrap: () -> AnyObject
    
    // MARK: - Init
    
    init<Concrete: CoalescibleOperation>(_ concrete: Concrete) where Concrete.Value == T {
        _identifier = { concrete.identifier }
        _completionHandler = { concrete.completionHandler }
        _callBackQueue = { concrete.callBackQueue }
        _complete = { concrete.complete(result: $0) }
        _coalesce = { concrete.coalesce(operation: $0) }
        _unwrap = { concrete as AnyObject }
    }
    
    // MARK: - Actions
    
    func complete(result: Result<T, Error>) {
        _complete(result)
    }
    
    func coalesce(operation: AnyCoalescibleOperation<T>) {
        _coalesce(operation)
    }
    
    func unwrap() -> AnyObject {
        _unwrap()
    }
}
