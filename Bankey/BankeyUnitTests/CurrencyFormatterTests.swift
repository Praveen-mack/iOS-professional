//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by praveen mack on 22/01/22.
//

import Foundation
import XCTest

@testable import Bankey

class test: XCTestCase {
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(984943.52)
        XCTAssertEqual(result.0, "984,943")
        XCTAssertEqual(result.1, "52")
    }
    
    func testDollarsFormatter() throws {
        let result = formatter.dollarsFormatted(723467.24)
        XCTAssertEqual(result, "$723,467.24")
    }
    
    func testZeroDollarsFormatter() throws {
        let result = formatter.dollarsFormatted(0.00)
        XCTAssertEqual(result, "$0.00")
    }
    
    func testDollarsFormattedWithCurrenySymbol() throws {
        let local = Locale.current
        let currencySymbol = local.currencySymbol!
        
        let result = formatter.dollarsFormatted(656735.33)
        XCTAssertEqual(result, "\(currencySymbol)656,735.33")
    }
}
