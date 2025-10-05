
//
//  PersistenceController.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import Foundation

/// Handles persistence of user coin preferences using UserDefaults
struct PersistenceController {
    static let shared = PersistenceController()
    
    private let coinKey = "savedCoinIDs"
    private let autoUpdateKey = "autoUpdateEnabled"
    private let defaults = UserDefaults.standard
    
    /// Saves the user's selected coins to UserDefaults
    /// - Parameter coins: Array of coins to save
    func saveCoins(_ coins: [Coin]) {
        let coinIDs = coins.map { $0.id }
        defaults.set(coinIDs, forKey: coinKey)
    }

    /// Loads the user's saved coins from UserDefaults
    /// - Returns: Array of coins with basic information (prices will be fetched separately)
    func loadCoins() -> [Coin] {
        guard let coinIDs = defaults.array(forKey: coinKey) as? [String] else {
            // Return default coins if none are saved
            return getDefaultCoins()
        }
        
        // Create basic coin objects - prices will be populated by the view model
        return coinIDs.map { coinID in
            Coin(
                id: coinID,
                symbol: "",
                name: coinID.capitalized,
                image: "",
                currentPrice: 0,
                priceChange24h: 0,
                priceChangePercentage24h: 0
            )
        }
    }
    
    /// Saves the auto-update preference
    /// - Parameter enabled: Whether auto-update is enabled
    func saveAutoUpdateEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: autoUpdateKey)
    }
    
    /// Loads the auto-update preference
    /// - Returns: Whether auto-update is enabled (defaults to true)
    func loadAutoUpdateEnabled() -> Bool {
        return defaults.object(forKey: autoUpdateKey) as? Bool ?? true
    }
    
    /// Returns the default set of coins when no preferences are saved
    /// - Returns: Array of default cryptocurrency coins
    private func getDefaultCoins() -> [Coin] {
        return [
            Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "", currentPrice: 0, priceChange24h: 0, priceChangePercentage24h: 0),
            Coin(id: "ethereum", symbol: "eth", name: "Ethereum", image: "", currentPrice: 0, priceChange24h: 0, priceChangePercentage24h: 0),
            Coin(id: "solana", symbol: "sol", name: "Solana", image: "", currentPrice: 0, priceChange24h: 0, priceChangePercentage24h: 0)
        ]
    }
}
