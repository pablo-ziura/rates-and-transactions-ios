//
//  TransactionsRemoteService.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

struct TransactionsRemoteService: TransactionsService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getTransactions() async throws -> [Transaction] {
        let url = URLConstants.baseUrl + URLConstants.transactionsEndpoint
        let remoteTransactions: [TransactionRemote] = try await networkClient.getCall(url: url, queryParams: nil)
        return remoteTransactions.map(TransactionRemoteMapper.map)
    }
}
