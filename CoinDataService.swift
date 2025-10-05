//
//  CoinDataService.swift
//  CryptoTicker
//
//  Created on 2024
//  Copyright © 2024 CryptoTicker. All rights reserved.
//

import Foundation
import Combine

/// Service responsible for fetching cryptocurrency data from the CoinGecko API
class CoinDataService: ObservableObject {
    private let baseURL = "https://api.coingecko.com/api/v3"
    private let session = URLSession.shared
    
    /// Fetches current price data for the specified coin IDs
    /// - Parameter coinIDs: Array of coin IDs to fetch data for
    /// - Returns: Publisher that emits an array of Coin objects
    func fetchCoinData(for coinIDs: [String]) -> AnyPublisher<[Coin], Error> {
        let idsString = coinIDs.joined(separator: ",")
        let urlString = "\(baseURL)/coins/markets?vs_currency=usd&ids=\(idsString)&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> [Coin] in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                let decoder = JSONDecoder()
                return try decoder.decode([Coin].self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    /// Searches for coins by name or symbol
    /// - Parameter query: Search query string
    /// - Returns: Publisher that emits an array of matching Coin objects
    func searchCoins(query: String) -> AnyPublisher<[Coin], Error> {
        let urlString = "\(baseURL)/search?query=\(query)"
        
        guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> [Coin] in
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(CoinSearchResult.self, from: data)
                
                return searchResult.coins.prefix(10).map { coinInfo in
                    Coin(
                        id: coinInfo.id,
                        symbol: coinInfo.symbol,
                        name: coinInfo.name,
                        image: coinInfo.large,
                        currentPrice: nil,
                        priceChange24h: nil,
                        priceChangePercentage24h: nil
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Supporting Data Models

/// Represents search results from the CoinGecko search endpoint
private struct CoinSearchResult: Codable {
    let coins: [CoinSearchInfo]
}

/// Individual coin information from search results
private struct CoinSearchInfo: Codable {
    let id: String
    let name: String
    let symbol: String
    let large: String?
}