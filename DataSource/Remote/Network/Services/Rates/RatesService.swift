//
//  RatesService.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

protocol RatesService {
    func getRates() async throws -> [Rate]
}
