//
//  Transaction.swift
//  currency_rates
//
//  Created by Carlos Garcia Vicen on 19/1/24.
//

import Foundation

struct Transaction: Codable, Hashable {
    let sku, currency: String
    let amount: String
}
