//
//  RateRemoteMapper.swift
//  currency_rates
//
//  Created by Carlos Garcia Vicen on 22/1/24.
//

import Foundation

struct RateRemoteMapper {
    static func map(_ remoteRate: RateRemote) -> Rate {
        return Rate(
            from: remoteRate.from,
            to: remoteRate.to,
            rate: remoteRate.rate
        )
    }
}
