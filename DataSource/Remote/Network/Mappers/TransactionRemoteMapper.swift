//
//  TransactionRemoteMapper.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 22/1/24.
//

import Foundation

struct TransactionRemoteMapper {
    static func map(_ remoteTransaction: TransactionRemote) -> Transaction {
        return Transaction(
            sku: remoteTransaction.sku,
            currency: remoteTransaction.currency,
            amount: remoteTransaction.amount
        )
    }
}
