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
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let apiKey = Bundle.main.coinAPIKey {
            request.setValue(apiKey, forHTTPHeaderField: "x-access-token")
        } else {
            // what do I do here? Cuurently the Api call works without an API key and may run out of the set limits for free version
            print("Warning: Coin API key not found. API requests may fail.")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate HTTP status code
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response into the expected type
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
