//
//  CoalescingOperationFactory.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 28/02/2026.
//

import Foundation

protocol OperationFactory {
    func createUserFetchOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) -> UserFetchOperation
}

struct DefaultOperationFactory: OperationFactory {
    func createUserFetchOperation(completionHandler: @escaping (Result<Bool, Error>) -> Void) -> UserFetchOperation {
        UserFetchOperation(completionHandler: completionHandler)
    }
}
