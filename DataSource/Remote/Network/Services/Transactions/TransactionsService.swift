//
//  TransactionsService.swift
//  currency_rates
//
//  Created by Carlos Garcia Vicen on 19/1/24.
//

import Foundation

protocol TransactionsService {
    func getTransactions() async throws -> [Transaction]
}
