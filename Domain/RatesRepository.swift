//
//  RatesRepository.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

class RatesRepository {
    
    private let remoteService: RatesService
    private var error: Error?
    
    init(remoteService: RatesService) {
        self.remoteService = remoteService
    }
    
    func getRates() async throws -> [Rate] {
        do {
            let rates = try await remoteService.getRates()
            return rates
        } catch let error {
            self.error = error
            print("Error: ", error)
            throw error
        }
    }
}
