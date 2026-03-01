//
//  StubCoalescibleOperation.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

final class StubCoalescibleOperation<T>: Operation, CoalescibleOperation, @unchecked Sendable {
    enum Event {
        case finish(Result<T, Error>)
        case coalesce(AnyCoalescibleOperation<T>)
    }
    
    private(set) var events: [Event] = []
    
    let identifier: String
    let completionHandler: (Result<T, Error>) -> Void
    let callBackQueue: OperationQueue
    
    var coalesceToBeReturned = true
    
    init(identifier: String = "test_identifier",
         callBackQueue: OperationQueue = .main,
         completionHandler: @escaping (_ result: Result<T, Error>) -> Void = { _ in }) {
        self.identifier = identifier
        self.completionHandler = completionHandler
        self.callBackQueue = callBackQueue
    }
    
    func finish(result: Result<T, Error>) {
        events.append(.finish(result))
    }
    
    func coalesce(operation: AnyCoalescibleOperation<T>) -> Bool {
        events.append(.coalesce(operation))
        
        return coalesceToBeReturned
    }
}

extension StubCoalescibleOperation: AnyCoalescibleOperationConvertible {
    func eraseToAnyCoalescibleOperation<U>() -> AnyCoalescibleOperation<U>? {
        guard let typed = self as? StubCoalescibleOperation<U> else {
            return nil
        }
        
        return AnyCoalescibleOperation(typed)
    }
}
