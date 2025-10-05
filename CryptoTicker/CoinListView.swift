
//
//  CoinListView.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// View that displays the list of cryptocurrency coins or loading/error states
struct CoinListView: View {
    @ObservedObject var viewModel: CoinViewModel

    var body: some View {
        if viewModel.isLoading && viewModel.coinData.isEmpty {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Loading Coins...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundColor(.orange)
                Text("Error")
                    .font(.headline)
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    viewModel.fetchCoinData()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.coinData) { coin in
                CoinRow(coin: coin)
            }
            .listStyle(PlainListStyle())
        }
    }
}
