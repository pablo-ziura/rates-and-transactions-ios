//
//  RateRemote.swift
//  currency_rates
//
//  Created by Carlos Garcia Vicen on 22/1/24.
//

import Foundation

struct RateRemote: Decodable {
    let from: String
    let to: String
    let rate: String
}
