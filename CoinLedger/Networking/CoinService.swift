//
//  CoinService.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation

// MARK: - CoinService
/// Handles all networking related to Coins

struct CoinService {
    private let baseURL: String
    private let networkManager: NetworkManager

    init(baseURL: String = "https://api.coinranking.com/v2", networkManager: NetworkManager = NetworkManager()) {
        self.baseURL = baseURL
        self.networkManager = networkManager
    }
    
    /// Fetches a list of coins with optional sorting and pagination
    func fetchCoins(limit: Int, offset: Int, sortOption: CoinListSortOption = .none) async throws -> CoinListResponse {
        var urlComponents = URLComponents(string: "\(baseURL)/coins")!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        
        if let orderBy = sortOption.orderByParameter {
            queryItems.append(URLQueryItem(name: "orderBy", value: orderBy))
            queryItems.append(URLQueryItem(name: "orderDirection", value: "desc")) // Default: highest first
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let response: CoinListResponse = try await networkManager.fetchData(from: url)
        return response
    }
    
    /// Fetches detailed information for a specific coin by UUID
    func fetchCoinDetails(uuid: String, referenceCurrencyUuid: String = "yhjMzLPhuIDl", timePeriod: String = "24h") async throws -> CoinDetailsResponse {
        var urlComponents = URLComponents(string: "\(baseURL)/coin/\(uuid)")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "referenceCurrencyUuid", value: referenceCurrencyUuid),
            URLQueryItem(name: "timePeriod", value: timePeriod)
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let response: CoinDetailsResponse = try await networkManager.fetchData(from: url)
        return response
    }
}

/// Defines how the coin list can be sorted
enum CoinListSortOption {
    case none
    case highestPrice
    case best24hPerformance
    
    var orderByParameter: String? {
        switch self {
        case .none:
            return nil
        case .highestPrice:
            return "price"
        case .best24hPerformance:
            return "change"
        }
    }
}

/// Defines possible networking errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noInternet
    
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "Network error occurred due to invalid endpoint. Please try again."
        case .invalidResponse:
            return "Server error occurred. Please try again."
        case .noInternet:
            return "Seems you are offline. Please check your internet connection"
        }
    }
}
