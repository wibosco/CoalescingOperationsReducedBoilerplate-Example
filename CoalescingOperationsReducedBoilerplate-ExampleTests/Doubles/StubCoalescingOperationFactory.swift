//
//  StubCoalescingOperationFactory.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

final class StubCoalescingOperationFactory: CoalescingOperationFactory {
    enum Event {
        case createExampleOperation(((Result<Bool, Error>) -> Void))
    }
    
    private(set) var events: [Event] = []
    
    var operation: any (Operation & CoalescibleOperation)
    
    init(operation: (any Operation & CoalescibleOperation)) {
        self.operation = operation
    }
    
    func createExampleOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) -> any (Operation & CoalescibleOperation) {
        events.append(.createExampleOperation(completionHandler))
        
        return operation
    }
}
