//
//  TransactionsService.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

protocol TransactionsService {
    func getTransactions() async throws -> [Transaction]
}
