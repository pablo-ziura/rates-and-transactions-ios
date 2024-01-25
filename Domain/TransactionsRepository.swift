//
//  TransactionsRepository.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

class TransactionsRepository {
    
    private let remoteService: TransactionsService
    private var error: Error?
    
    init(remoteService: TransactionsService) {
        self.remoteService = remoteService
    }
    
    func getTransactions() async throws -> [Transaction] {
        do {
            let transactions = try await remoteService.getTransactions()
            return transactions
        } catch let error {
            self.error = error
            print("Error: ", error)
            throw error
        }
    }
}
