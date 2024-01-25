//
//  Extensions.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 22/1/24.
//

import Foundation

extension Double {
    func toStandardFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

