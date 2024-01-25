//
//  TransactionRemote.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 22/1/24.
//

import Foundation

struct TransactionRemote: Decodable {
    let sku: String
    let amount: String
    let currency: String
}
