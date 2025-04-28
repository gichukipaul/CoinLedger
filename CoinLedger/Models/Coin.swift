//
//  Coin.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation

// MARK: - Coin
struct Coin: Codable {
    let uuid, symbol, name, color: String
    let iconURL: String
    let marketCap, price: String
    let listedAt, tier: Int
    let change: String
    let rank: Int
    let sparkline: [String?]
    let lowVolume: Bool
    let coinrankingURL: String
    let the24HVolume, btcPrice: String
    let contractAddresses: [String]

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
        case btcPrice, contractAddresses
    }
}
