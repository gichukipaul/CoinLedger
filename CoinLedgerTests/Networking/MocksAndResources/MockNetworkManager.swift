//
//  MockNetworkManager.swift
//  CoinLedgerTests
//
//  Created by GICHUKI on 02/05/2025.
//

@testable import CoinLedger
import XCTest

final class MockNetworkManager: NetworkManager {
    var stubbedData: Data?
    var stubbedError: Error?
    
    override func fetchData<T: Decodable>(from url: URL) async throws -> T {
        if let error = stubbedError {
            throw error
        }
        guard let data = stubbedData else {
            throw NetworkError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
