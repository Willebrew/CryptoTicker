
import Foundation
import Combine

class CoinDataService {
    private var cancellables = Set<AnyCancellable>()

    func fetchCoinData(for coinIDs: [String]) -> Future<[Coin], Error> {
        let ids = coinIDs.joined(separator: ",")
        return Future { promise in
            guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(ids)&order=market_cap_desc&per_page=100&page=1&sparkline=false") else {
                promise(.failure(URLError(.badURL)))
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: [Coin].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { coinData in
                    promise(.success(coinData))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func searchCoins(query: String) -> Future<[Coin], Error> {
        return Future { promise in
            guard let url = URL(string: "https://api.coingecko.com/api/v3/search?query=\(query)") else {
                promise(.failure(URLError(.badURL)))
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: SearchResult.self, decoder: JSONDecoder())
                .map { $0.coins }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { coins in
                    promise(.success(coins))
                })
                .store(in: &self.cancellables)
        }
    }
}

struct SearchResult: Codable {
    let coins: [Coin]
}
