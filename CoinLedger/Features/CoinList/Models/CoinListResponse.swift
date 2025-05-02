//
//  CoinListResponse.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation

// MARK: - CoinListResponse
struct CoinListResponse: Codable {
    let status: String
    let data: CoinListDataClass
}

// MARK: - CoinListDataClassDataClass
struct CoinListDataClass: Codable {
    let stats: Stats
    let coins: [Coin]
}

// MARK: - Stats
struct Stats: Codable {
    let total, totalCoins, totalMarkets, totalExchanges: Int
    let totalMarketCap, total24HVolume: String
    
    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}
