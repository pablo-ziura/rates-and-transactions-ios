//
//  TransactionsHelper.swift
//  currency_rates
//
//  Created by Carlos Garcia Vicen on 22/1/24.
//

import Foundation

class TransactionsHelper {
    
    private var exchangeRatesMatrix: [[Double]]?
    private var matrixIndices: [String: Int]?

    // Using Floyd-Warshall Algorithm
    
    func calculateExchangeRates(rates: [Rate]) {
        let currencies = Set(rates.flatMap { [$0.from, $0.to] })
        let indices = Dictionary(uniqueKeysWithValues: currencies.enumerated().map { ($1, $0) })
        let numCurrencies = currencies.count
        var matrix = Array(repeating: Array(repeating: Double.greatestFiniteMagnitude, count: numCurrencies), count: numCurrencies)

        for i in matrix.indices {
            matrix[i][i] = 1.0
        }

        for rate in rates {
            guard let rateValue = Double(rate.rate),
                  let fromIndex = indices[rate.from],
                  let toIndex = indices[rate.to] else { continue }
            matrix[fromIndex][toIndex] = rateValue
            matrix[toIndex][fromIndex] = 1 / rateValue
        }

        for k in matrix.indices {
            for i in matrix.indices {
                for j in matrix.indices {
                    if matrix[i][j] > matrix[i][k] * matrix[k][j] {
                        matrix[i][j] = matrix[i][k] * matrix[k][j]
                    }
                }
            }
        }
        exchangeRatesMatrix = matrix
        matrixIndices = indices
    }

    func convertCurrency(amount: Double, fromCurrency: String, toCurrency: String) -> Double {
        guard let fromIndex = matrixIndices?[fromCurrency],
              let toIndex = matrixIndices?[toCurrency],
              let rate = exchangeRatesMatrix?[fromIndex][toIndex],
              rate != Double.greatestFiniteMagnitude else { return 0.0 }
        return amount * rate
    }
    
    func calculateTotalAmountConverted(transactions: [Transaction], forProduct product: String, toCurrency currency: String) -> Double {
        let filteredTransactions = transactions.filter { $0.sku == product }
        
        return filteredTransactions.reduce(0) { total, transaction in
            if let amount = Double(transaction.amount) {
                let convertedAmount = transaction.currency == currency ? amount : convertCurrency(amount: amount, fromCurrency: transaction.currency, toCurrency: currency)
                return total + convertedAmount
            }
            return total
        }
    }
}
