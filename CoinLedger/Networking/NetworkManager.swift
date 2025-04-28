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
    ///   - headers: Optional headers for the request.
    /// - Returns: A decoded object of type `T` or throws an error.
    func fetchData<T: Decodable>(from url: URL, headers: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Adding headers if provided
        if let headers = headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Perform the request using URLSession
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the response into the expected type
        let decoder = JSONDecoder()
        let response = try decoder.decode(T.self, from: data)
        
        return response
    }
}
