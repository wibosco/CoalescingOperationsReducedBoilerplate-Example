//
//  CoalescingExampleManager.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

protocol CoalescingExampleManager {
    func addExampleCoalescingOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void)
}

final class DefaultCoalescingExampleManager: CoalescingExampleManager {
    private let queueManager: OperationQueueManager
    private let factory: CoalescingOperationFactory
    
    // MARK: - Init
    
    init(queueManager: OperationQueueManager,
         factory: CoalescingOperationFactory) {
        self.queueManager = queueManager
        self.factory = factory
    }
    
    // MARK: - Add
    
    func addExampleCoalescingOperation(completionHandler: @escaping (_ result: Result<Bool, Error>) -> Void) {
        let operation = factory.createExampleOperation(completionHandler: completionHandler)
        
        queueManager.enqueue(operation: operation)
    }
}
