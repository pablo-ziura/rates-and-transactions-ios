//
//  Coordinator.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import Foundation

class Coordinator: ObservableObject {
    
    private let ratesRepository: RatesRepository
    private let transactionsRepository: TransactionsRepository
    
    init() {
        
        let networkClient = URLSessionNetworkClient()

        let ratesRemoteService: RatesService = RatesRemoteService(networkClient: networkClient)
        let transactionsRemoteService: TransactionsService = TransactionsRemoteService(networkClient: networkClient)
        
        ratesRepository = RatesRepository(remoteService: ratesRemoteService)
        transactionsRepository = TransactionsRepository(remoteService: transactionsRemoteService)
        
    }
    
    func createMarketPlaceViewModel() -> MarketPlaceViewModel {
        MarketPlaceViewModel(
            ratesRepository: ratesRepository,
            transactionsRepository: transactionsRepository
        )
    }
    
    func createMarketPlaceView() -> MarketPlaceView {
        MarketPlaceView(
            viewModel: createMarketPlaceViewModel()
        )
    }
    	
}
