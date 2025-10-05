
//
//  SettingsView.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// Settings view for managing the user's cryptocurrency list
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    var onDismiss: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Customize Coin List")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            // Search section
            VStack(spacing: 12) {
                HStack {
                    TextField("Search for a coin (e.g., cardano)", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit(viewModel.searchCoins)
                    
                    Button("Search", action: viewModel.searchCoins)
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.searchText.isEmpty)
                }

                if viewModel.isSearching {
                    ProgressView()
                        .frame(height: 50)
                } else if !viewModel.searchResults.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Search Results")
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        List(viewModel.searchResults) { coin in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(coin.name)
                                        .fontWeight(.medium)
                                    Text(coin.symbol.uppercased())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button("Add") { 
                                    viewModel.addCoin(coin) 
                                }
                                .buttonStyle(.bordered)
                                .disabled(viewModel.savedCoins.contains { $0.id == coin.id })
                            }
                        }
                        .frame(height: 150)
                    }
                }
            }
            
            Spacer()
            
            // Current coins section
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Coins")
                    .font(.headline)

                List {
                    ForEach(viewModel.savedCoins) { coin in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .fontWeight(.medium)
                                Text(coin.symbol.uppercased())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(role: .destructive) {
                                viewModel.removeCoin(coin)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onMove(perform: viewModel.moveCoin)
                }
                .frame(minHeight: 200)
            }

            // Done button
            HStack {
                Spacer()
                Button("Done") {
                    onDismiss?()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                Spacer()
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
        .frame(width: 400, height: 600)
        .onAppear(perform: viewModel.loadSavedCoins)
    }
}
