//
//  ContentView.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        MarketPlaceView(
            viewModel: coordinator.createMarketPlaceViewModel()
        )
    }

}

#Preview {
    let coordinator = Coordinator()
    return ContentView().environmentObject(coordinator)
}
