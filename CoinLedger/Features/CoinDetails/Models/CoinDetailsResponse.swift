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
