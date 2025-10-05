
//
//  CoinRow.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import SwiftUI

/// Individual row view for displaying a cryptocurrency's information
struct CoinRow: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {
            // Coin icon
            AsyncImage(url: URL(string: coin.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .overlay {
                        Text(String(coin.symbol.prefix(1)).uppercased())
                            .font(.caption)
                            .fontWeight(.medium)
                    }
            }
            .frame(width: 32, height: 32)

            // Coin name and symbol
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Price and change
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.currentPrice ?? 0, format: .currency(code: "USD"))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image(systemName: (coin.priceChangePercentage24h ?? 0) >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2)
                    Text(String(format: "%.2f%%", coin.priceChangePercentage24h ?? 0))
                        .font(.caption)
                }
                .foregroundColor((coin.priceChangePercentage24h ?? 0) >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 8)
    }
}
