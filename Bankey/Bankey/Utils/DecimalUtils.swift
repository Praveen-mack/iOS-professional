//
//  DecimalUtils.swift
//  Bankey
//
//  Created by praveen mack on 09/01/22.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
