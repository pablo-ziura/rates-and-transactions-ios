//
//  RatesRemoteService.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

struct RatesRemoteService: RatesService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getRates() async throws -> [Rate] {
        let url = URLConstants.baseUrl + URLConstants.ratesEndpoint
        let remoteRates: [RateRemote] = try await networkClient.getCall(url: url, queryParams: nil)
        return remoteRates.map(RateRemoteMapper.map)
    }
}
