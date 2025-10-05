
//
//  CoinViewModel.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import Foundation
import Combine

/// ViewModel responsible for managing cryptocurrency data and UI state
class CoinViewModel: ObservableObject {
    @Published var coinData: [Coin] = []
    @Published var lastUpdated: Date? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var autoUpdateEnabled = true

    private var cancellables = Set<AnyCancellable>()
    private let service = CoinDataService()
    private let persistence = PersistenceController.shared
    private var updateTimer: Timer?
    
    private let updateInterval: TimeInterval = 120 // 2 minutes

    init() {
        // Load saved auto-update preference
        autoUpdateEnabled = persistence.loadAutoUpdateEnabled()
        
        fetchCoinData()
        startAutoUpdate()
    }
    
    deinit {
        stopAutoUpdate()
    }

    /// Starts automatic price updates
    private func startAutoUpdate() {
        guard autoUpdateEnabled else { return }
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.fetchCoinData()
        }
    }
    
    /// Stops automatic price updates
    private func stopAutoUpdate() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Toggles auto-update functionality
    func toggleAutoUpdate() {
        autoUpdateEnabled.toggle()
        
        // Save preference
        persistence.saveAutoUpdateEnabled(autoUpdateEnabled)
        
        if autoUpdateEnabled {
            startAutoUpdate()
        } else {
            stopAutoUpdate()
        }
    }

    /// Fetches current cryptocurrency data for saved coins
    func fetchCoinData() {
        let savedCoins = persistence.loadCoins()
        let coinIDs = savedCoins.map { $0.id }
        
        guard !coinIDs.isEmpty else { 
            errorMessage = "No coins selected. Please add coins in settings."
            return 
        }
        
        isLoading = true
        errorMessage = nil
        
        service.fetchCoinData(for: coinIDs)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] coinData in
                // Sort coins to match the user's preferred order
                guard let self = self else { return }
                let sortedData = coinData.sorted { coin1, coin2 in
                    let index1 = coinIDs.firstIndex(of: coin1.id) ?? Int.max
                    let index2 = coinIDs.firstIndex(of: coin2.id) ?? Int.max
                    return index1 < index2
                }
                self.coinData = sortedData
                self.lastUpdated = Date()
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}
