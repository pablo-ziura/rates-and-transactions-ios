//
//  MarketPlaceView.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import SwiftUI

struct MarketPlaceView: View {
    
    @State private var selectedCurrency: String = "N/A"
    @State private var selectedProduct: String = "N/A"
       
    @StateObject private var viewModel: MarketPlaceViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    init(viewModel: MarketPlaceViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(viewModel.currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                Picker("Product", selection: $selectedProduct) {
                    ForEach(viewModel.products, id: \.self) { product in
                        Text(product)
                    }
                }
                List(viewModel.filterTransactions, id: \.self) { transaction in
                    HStack {
                        Text(transaction.sku)
                        Spacer()
                        Text("\(transaction.amount) \(transaction.currency)")
                        let amount = Double(transaction.amount.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let convertedAmount = viewModel.convertCurrency(amount: amount, fromCurrency: transaction.currency, toCurrency: selectedCurrency)
                        Text("-> \(convertedAmount.toStandardFormat()) \(selectedCurrency)")
                    }
                }
                Text("Total: \(calculateTotal().toStandardFormat()) \(selectedCurrency)")
                    .redacted(reason: selectedCurrency == "N/A" ? .placeholder : [])
                    .padding()
            }
        }
        .onChange(of: selectedProduct, {
            viewModel.filterTransactions(byProduct: selectedProduct)
        })
        .animation(.default, value: viewModel.filterTransactions)
        .padding()
        .task {
            await viewModel.getRates()
            await viewModel.getTransactions()
            if let firstCurrency = viewModel.currencies.first {
                selectedCurrency = firstCurrency
            }
            if let firstProduct = viewModel.products.first {
                selectedProduct = firstProduct
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Reintentar") {
                
            }
        } message: {
            Text("Error al cargar las tasas de cambio")
        }
    }
    
    private func requestData() {
        Task {
            await viewModel.getRates()
            await viewModel.getTransactions()
        }
    }
    
    private func convertCurrency(amount: Double, fromCurrency: String, toCurrency: String) -> Double {
        viewModel.convertCurrency(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
    
    private func calculateTotal() -> Double {
        viewModel.filterTransactions
            .reduce(0) { total, transaction in
                let amount = Double(transaction.amount.replacingOccurrences(of: ",", with: ".")) ?? 0
                let convertedAmount = viewModel.convertCurrency(amount: amount, fromCurrency: transaction.currency, toCurrency: selectedCurrency)
                return total + convertedAmount
        }
    }
}

#Preview {
    let coordinator = Coordinator()
    return coordinator
        .createMarketPlaceView()
        .environmentObject(coordinator)
}
