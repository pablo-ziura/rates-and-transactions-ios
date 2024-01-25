//
//  MarketPlaceViewModel.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

class MarketPlaceViewModel: ObservableObject {
    
    @Published var rates: [Rate] = []
    @Published var transactions: [Transaction] = []
    
    @Published var filterTransactions: [Transaction] = []
    
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showErrorAlert = false

    private let ratesRepository: RatesRepository
    private let transactionsRepository: TransactionsRepository
    
    private let transactionsHelper = TransactionsHelper()
    
    private var exchangeRatesMatrix: [[Double]]?
    private var matrixIndices: [String: Int]?

    var currencies: [String] {
        let uniqueCurrencies = Set(rates.map { $0.to })
        return Array(uniqueCurrencies).sorted()
    }
    
    var products: [String] {
        let uniqueProducts = Set(transactions.map { $0.sku })
        return Array(uniqueProducts).sorted()
    }
    
    init(ratesRepository: RatesRepository, transactionsRepository: TransactionsRepository) {
        self.ratesRepository = ratesRepository;
        self.transactionsRepository = transactionsRepository
    }
    
    @MainActor
    func getRates() async {
        isLoading = true
        do {
            rates = try await ratesRepository.getRates()
            transactionsHelper.calculateExchangeRates(rates: rates)
            showErrorAlert = false
        } catch {
            self.error = error
            showErrorAlert = true
        }
        isLoading = false
    }

    @MainActor
    func getTransactions() async {
        isLoading = true
        do {
            transactions = try await transactionsRepository.getTransactions()
            showErrorAlert = false
        } catch {
            self.error = error
            showErrorAlert = true
        }
        isLoading = false
    }

    
    func filterTransactions(byProduct product: String) {
        filterTransactions = transactions.filter { $0.sku == product }
    }
    
    func convertCurrency(amount: Double, fromCurrency: String, toCurrency: String) -> Double {
        transactionsHelper.convertCurrency(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
}
