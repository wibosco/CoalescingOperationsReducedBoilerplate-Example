//
//  CoalescingExampleOperation.swift
//  CoalescingOperationsReducedBoilerplate-Example
//
//  Created by Boles on 28/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

class UserFetchOperation: DefaultCoalescibleOperation<Bool>, @unchecked Sendable {
    // MARK: - Init
    
    init(completionHandler: @escaping  (_ result: Result<Bool, Error>) -> Void) {
        super.init(identifier: "UserFetchOperation",
                   completionHandler: completionHandler)
    }
    
    // MARK: - Lifecycle
    
    override func main() {
        super.main()
        
        // Do work here
        sleep(5)
        
        finish(result: .success(true))
    }
}
