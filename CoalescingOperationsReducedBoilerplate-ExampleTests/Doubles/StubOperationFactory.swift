//
//  StubCoalescingOperationFactory.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

@testable import CoalescingOperationsReducedBoilerplate_Example

final class StubOperationFactory: OperationFactory {
    enum Event {
        case createExampleOperation(((Result<Bool, Error>) -> Void))
    }
    
    private(set) var events: [Event] = []
    
    var operation: UserFetchOperation
    
    init(operation: UserFetchOperation) {
        self.operation = operation
    }
    
    func createUserFetchOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) -> UserFetchOperation {
        events.append(.createExampleOperation(completionHandler))
        
        return operation
    }
}
