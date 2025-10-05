
//
//  ContentView.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// Main content view that displays the cryptocurrency dashboard
struct ContentView: View {
    @StateObject private var viewModel = CoinViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
            Divider()
            CoinListView(viewModel: viewModel)
        }
        .frame(width: 300, height: 400)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
