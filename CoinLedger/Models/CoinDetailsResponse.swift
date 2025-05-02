//
//  CoinDetailsResponse.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import Foundation

// MARK: - CoinDetailsResponse
struct CoinDetailsResponse: Codable {
    let status: String
    let data: CoinDetailsDataClass
}

// MARK: - CoinDetailsDataClass
struct CoinDetailsDataClass: Codable {
    let coin: CoinDetails
}

// MARK: - Coin
struct CoinDetails: Codable {
    let uuid, symbol, name: String
    let color: String?
    let description: String?
    let iconURL: String
    let marketCap: String?
    let websiteURL: String?
    let links: [CoinLink]
    let supply: Supply?
    let numberOfMarkets, numberOfExchanges: Int
    let the24HVolume, fullyDilutedMarketCap, price: String
    let btcPrice: String
    let priceAt: Int
    let change: String
    let rank: Int
    let sparkline: [String?]
    let allTimeHigh: AllTimeHigh
    let coinrankingURL: String
    let tier: Int
    let lowVolume: Bool
    let listedAt: Int
    let hasContent: Bool
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, color
        case iconURL = "iconUrl"
        case websiteURL = "websiteUrl"
        case links, supply, numberOfMarkets, numberOfExchanges
        case the24HVolume = "24hVolume"
        case marketCap, fullyDilutedMarketCap, price, btcPrice, priceAt, change, rank, sparkline, allTimeHigh
        case coinrankingURL = "coinrankingUrl"
        case tier, lowVolume, listedAt, hasContent
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    let price: String
    let timestamp: Int
}

// MARK: - Link
struct CoinLink: Codable {
    let name: String
    let url: String
    let type: String
}

// MARK: - Supply
struct Supply: Codable {
    let confirmed: Bool
    let supplyAt: Int
    let max, total: String?
    let circulating: String?
}
