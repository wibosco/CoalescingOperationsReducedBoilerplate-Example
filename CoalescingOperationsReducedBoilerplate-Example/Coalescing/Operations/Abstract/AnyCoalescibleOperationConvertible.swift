//
//  AnyCoalescibleOperationConvertible.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by William Boles on 01/03/2026.
//  Copyright © 2026 Boles. All rights reserved.
//

import Foundation

protocol AnyCoalescibleOperationConvertible {
    var identifier: String { get }
    
    func eraseToAnyCoalescibleOperation<U>() -> AnyCoalescibleOperation<U>?
}

extension DefaultCoalescibleOperation: AnyCoalescibleOperationConvertible {
    func eraseToAnyCoalescibleOperation<U>() -> AnyCoalescibleOperation<U>? {
        guard let typed = self as? DefaultCoalescibleOperation<U> else {
            return nil
        }
        
        return AnyCoalescibleOperation(typed)
    }
}
