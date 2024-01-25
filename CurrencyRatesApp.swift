//
//  currency_ratesApp.swift
//  currency_rates
//
//  Created by Pablo Ruiz on 19/1/24.
//

import SwiftUI

@main
struct currencyRatesApp: App {
    let coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
        }
    }
}
