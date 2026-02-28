//
//  DefaultCoalescingOperationFactoryTests.swift
//  CoalescingOperationsReducedBoilerplate-ExampleTests
//
//  Created by William Boles on 28/02/2026.
//

import XCTest

@testable import CoalescingOperationsReducedBoilerplate_Example

final class DefaultCoalescingOperationFactoryTests: XCTestCase {
    private var sut: DefaultCoalescingOperationFactory!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        sut = DefaultCoalescingOperationFactory()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: Create
    
    func test_createExampleOperation_thenReturnsCoalescingExampleOperation() {
        let operation = sut.createExampleOperation { _ in }
        
        XCTAssertTrue(operation is CoalescingExampleOperation)
    }
}
