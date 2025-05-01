//
//  NetworkManager.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation
// MARK: - NetworkManager
/// A generic network manager for handling HTTP requests.
class NetworkManager {
    
    /// Makes a GET request to the given URL.
    /// - Parameters:
    ///   - url: The URL to send the GET request to.
    /// - Returns: A decoded object of type `T` or throws an error.
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let apiKey = Bundle.main.coinAPIKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        } else {
            print("Warning: Coin API key not found. API requests may fail.")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
