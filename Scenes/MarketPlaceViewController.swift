//
//  ViewController.swift
//  CurrencyRatesUIKit
//
//  Created by Carlos Garcia Vicen on 22/1/24.
//

import UIKit
import Combine

class MarketPlaceViewController: UIViewController {
    
    var coordinator: Coordinator!
    var viewModel: MarketPlaceViewModel!

    @IBOutlet weak var pickerCurrency: UIPickerView!
    @IBOutlet weak var pickerProduct: UIPickerView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    
    private var selectedCurrency: String?
    private var selectedProduct: String?

    private var cancellablesCurrencies: Set<AnyCancellable> = []
    private var cancellablesProducts: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = coordinator.createMarketPlaceViewModel()
        
        setupCurrencyPickerView()
        setupProductPickerView()
        setupTransactionsTableView()
        bindViewModel()
    }
    
    private func setupCurrencyPickerView() {
        pickerCurrency.delegate = self
        pickerCurrency.dataSource = self
    }
    
    private func setupProductPickerView() {
        pickerProduct.delegate = self
        pickerProduct.dataSource = self
    }
    
    private func setupTransactionsTableView() {
        transactionsTableView.dataSource = self
    }
    
    private func updateTotalAmountLabel() {
        if let currency = selectedCurrency, let product = selectedProduct {
            viewModel.filterTransactions(byProduct: product)
            let totalAmountConverted = viewModel.calculateTotalAmountConverted(forProduct: product, toCurrency: currency)
            totalAmount.text = "\(product), Total: \(String(format: "%.2f", totalAmountConverted)) \(currency)"
            transactionsTableView.reloadData()
        }
    }

    private func bindViewModel() {	
        viewModel.$rates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.pickerCurrency.reloadAllComponents()
            }
            .store(in: &cancellablesCurrencies)

        viewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.pickerProduct.reloadAllComponents()
                self?.transactionsTableView.reloadData()
            }
            .store(in: &cancellablesProducts)

        Task {
            await viewModel.getRates()
            if let firstCurrency = viewModel.currencies.first {
                selectedCurrency = firstCurrency
                DispatchQueue.main.async {
                    self.pickerCurrency.selectRow(0, inComponent: 0, animated: false)
                    self.updateTotalAmountLabel()
                }
            }
        }
        
        Task {
            await viewModel.getTransactions()
            if let firstProduct = viewModel.products.first {
                selectedProduct = firstProduct
                DispatchQueue.main.async {
                    self.pickerProduct.selectRow(0, inComponent: 0, animated: false)
                    self.viewModel.filterTransactions(byProduct: firstProduct)
                    self.transactionsTableView.reloadData()
                    self.updateTotalAmountLabel()
                }
            }
        }
    }
}

extension MarketPlaceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerCurrency {
            return viewModel.currencies.count
        } else if pickerView == pickerProduct {
            return viewModel.products.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerCurrency {
            return viewModel.currencies[row]
        } else if pickerView == pickerProduct {
            return viewModel.products[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerCurrency {
            selectedCurrency = viewModel.currencies[row]
        } else if pickerView == pickerProduct {
            selectedProduct = viewModel.products[row]
        }
        updateTotalAmountLabel()
    }
}

extension MarketPlaceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction = viewModel.filterTransactions[indexPath.row]
        
        var config = cell.defaultContentConfiguration()

        if let amount = Double(transaction.amount), let selectedCurrency = selectedCurrency {
            let convertedAmount = viewModel.convertCurrency(amount: amount, fromCurrency: transaction.currency, toCurrency: selectedCurrency)
            config.text = "\(transaction.sku) - \(String(format: "%.2f", convertedAmount)) \(selectedCurrency)"
        }
        
        config.textProperties.alignment = .center
        cell.contentConfiguration = config
        return cell
    }

}
