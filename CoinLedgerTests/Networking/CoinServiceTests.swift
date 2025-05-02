//
//  CoinServiceTests.swift
//  CoinLedgerTests
//
//  Created by GICHUKI on 02/05/2025.
//

import XCTest
@testable import CoinLedger

final class CoinServiceTests: XCTestCase {
    private var mockNetworkManager: MockNetworkManager!
    private var coinService: CoinService!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        coinService = CoinService(networkManager: mockNetworkManager)
    }

    // MARK: - Happy Flow
    func test_fetchCoins_returnsParsedDataSuccessfully() async throws {
        // Title: Happy Flow - Valid response is decoded correctly
        // Input: Stubbed valid CoinListResponse JSON
        // Expected Output: Coins parsed successfully

        mockNetworkManager.stubbedData = try loadJSON(named: "coins_success")

        let result = try await coinService.fetchCoins(limit: 20, offset: 0, sortOption: .highestPrice)

        XCTAssertEqual(result.data.coins.count, 20)
        XCTAssertEqual(result.data.coins.first?.name, "Bitcoin")
    }

    func test_fetchCoinDetails_returnsCorrectCoin() async throws {
        // Title: Happy Flow - Coin details parsed successfully
        // Input: Valid coin UUID and JSON stub
        // Expected Output: Matching UUID and name fields

        mockNetworkManager.stubbedData = try loadJSON(named: "coin_detail_success")

        let result = try await coinService.fetchCoinDetails(uuid: "Qwsogvtv82FCd")

        XCTAssertEqual(result.data.coin.name, "Bitcoin")
        XCTAssertEqual(result.data.coin.uuid, "Qwsogvtv82FCd")
    }


    func test_fetchCoins_withUnknownSortOption_returnsDefaultSortedData() async throws {
        // Title: Edge Case - .none sortOption
        // Input: sortOption = .none, stubbed JSON
        // Expected Output: Coins parsed, no crash

        mockNetworkManager.stubbedData = try loadJSON(named: "coins_success")

        let result = try await coinService.fetchCoins(limit: 20, offset: 0, sortOption: .none)
        XCTAssertEqual(result.data.coins.count, 20)
    }

    // MARK: - Helpers
    private func loadJSON(named name: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            fatalError("Missing file: \(name).json")
        }
        return try Data(contentsOf: url)
    }
}

