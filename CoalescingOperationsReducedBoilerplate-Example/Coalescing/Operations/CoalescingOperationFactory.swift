//
//  CoalescingOperationFactory.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

protocol CoalescingOperationFactory {
    func createExampleOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) -> any (Operation & CoalescibleOperation)
}

struct DefaultCoalescingOperationFactory: CoalescingOperationFactory {
    func createExampleOperation(completionHandler: @escaping (Result<Bool, any Error>) -> Void) -> any (Operation & CoalescibleOperation) {
        CoalescingExampleOperation(completionHandler: completionHandler)
    }
}
