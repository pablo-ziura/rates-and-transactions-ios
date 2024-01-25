//
//  Rate.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

struct Rate: Codable {
    let from, to: String
    let rate: String
}
