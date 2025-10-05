
//
//  SettingsViewModel.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import Foundation
import Combine

/// ViewModel for managing settings and coin selection functionality
class SettingsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Coin] = []
    @Published var isSearching = false
    @Published var savedCoins: [Coin] = []

    private var cancellables = Set<AnyCancellable>()
    private let coinDataService = CoinDataService()
    private let persistence = PersistenceController.shared

    /// Searches for cryptocurrencies based on the search text
    func searchCoins() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { 
            return 
        }
        
        isSearching = true
        searchResults = []
        
        coinDataService.searchCoins(query: searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isSearching = false
                if case .failure(let error) = completion {
                    print("Search failed: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] coins in
                self?.searchResults = coins
            })
            .store(in: &cancellables)
    }

    /// Adds a coin to the user's saved list
    /// - Parameter coin: The coin to add
    func addCoin(_ coin: Coin) {
        guard !savedCoins.contains(where: { $0.id == coin.id }) else { 
            return 
        }
        
        savedCoins.append(coin)
        persistence.saveCoins(savedCoins)
        
        // Clear search results after adding
        searchResults = []
        searchText = ""
    }

    /// Removes a coin from the user's saved list
    /// - Parameter coin: The coin to remove
    func removeCoin(_ coin: Coin) {
        savedCoins.removeAll { $0.id == coin.id }
        persistence.saveCoins(savedCoins)
    }

    /// Moves a coin to a new position in the list
    /// - Parameters:
    ///   - source: Source indices
    ///   - destination: Destination index
    func moveCoin(from source: IndexSet, to destination: Int) {
        savedCoins.move(fromOffsets: source, toOffset: destination)
        persistence.saveCoins(savedCoins)
    }

    /// Loads the user's saved coins from persistence
    func loadSavedCoins() {
        self.savedCoins = persistence.loadCoins()
    }
}
