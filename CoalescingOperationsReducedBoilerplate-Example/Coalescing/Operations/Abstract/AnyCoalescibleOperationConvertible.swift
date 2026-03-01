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
    
    func eraseToAnyCoalescibleOperation<TargetValue>() -> AnyCoalescibleOperation<TargetValue>?
}

extension DefaultCoalescibleOperation: AnyCoalescibleOperationConvertible {
    func eraseToAnyCoalescibleOperation<TargetValue>() -> AnyCoalescibleOperation<TargetValue>? {
        guard let typed = self as? DefaultCoalescibleOperation<TargetValue> else {
            return nil
        }
        
        return AnyCoalescibleOperation(typed)
    }
}
