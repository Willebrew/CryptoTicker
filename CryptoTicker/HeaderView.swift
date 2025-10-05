
//
//  HeaderView.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// Header view containing app title, last updated time, and action buttons
struct HeaderView: View {
    @ObservedObject var viewModel: CoinViewModel
    @State private var showingSettings = false

    var body: some View {
        HStack {
            Text("CryptoTicker")
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    if viewModel.autoUpdateEnabled {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)
                    }
                    Text("Last Updated:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                if let lastUpdated = viewModel.lastUpdated {
                    Text(lastUpdated, style: .time)
                        .font(.caption)
                } else {
                    Text("Never")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if viewModel.autoUpdateEnabled {
                    Text("Auto: 2min")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }

            Button(action: {
                viewModel.toggleAutoUpdate()
            }) {
                Image(systemName: viewModel.autoUpdateEnabled ? "timer" : "timer.slash")
                    .font(.title2)
                    .foregroundColor(viewModel.autoUpdateEnabled ? .green : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .help(viewModel.autoUpdateEnabled ? "Disable auto-update" : "Enable auto-update")

            Button(action: {
                viewModel.fetchCoinData()
            }) {
                Image(systemName: viewModel.isLoading ? "arrow.clockwise.circle.fill" : "arrow.clockwise.circle.fill")
                    .font(.title2)
                    .foregroundColor(viewModel.isLoading ? .secondary : .primary)
                    .rotationEffect(.degrees(viewModel.isLoading ? 360 : 0))
                    .animation(viewModel.isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isLoading)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.isLoading)
            
            Button(action: {
                showingSettings.toggle()
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingSettings, onDismiss: {
                viewModel.fetchCoinData()
            }) {
                SettingsView()
            }
        }
        .padding()
    }
}
