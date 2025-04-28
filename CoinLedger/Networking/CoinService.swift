//
//  CoinService.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation

// MARK: - CoinService

/// A service responsible for fetching coin data from the API.
class CoinService {

    private let networkManager = NetworkManager()
    
    private let baseURL = URL(string: "https://api.coinranking.com/v2/coins")!
    
    /// Fetches a paginated list of coins.
    /// - Parameter page: The page number to fetch.
    /// - Returns: A list of coins and total stats.
    func fetchCoins(page: Int) async throws -> CoinListResponse {
        let url = baseURL.appending("page=\(page)&limit=20")
        return try await networkManager.fetchData(from: url)
    }
}
