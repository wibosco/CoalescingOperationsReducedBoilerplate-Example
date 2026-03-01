//
//  CoalescingExampleManager.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

protocol UserDataManager {
    func fetchUser(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void)
}

final class DefaultUserDataManager: UserDataManager {
    private let queueManager: OperationQueueManager
    private let factory: OperationFactory
    
    // MARK: - Init
    
    init(queueManager: OperationQueueManager,
         factory: OperationFactory) {
        self.queueManager = queueManager
        self.factory = factory
    }
    
    // MARK: - Add
    
    func fetchUser(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) {
        let operation = factory.createUserFetchOperation(completionHandler: completionHandler)
        
        queueManager.enqueue(operation: operation)
    }
}
