//
//  CoinStatsView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//


import SwiftUI

struct CoinStatsView: View {
    let coin: CoinDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
                .font(.headline)
            statRow(label: "Market Cap", value: "$\(coin.marketCap ?? "")")
            statRow(label: "24h Volume", value: "$\(coin.the24HVolume)")
            statRow(label: "All-Time High", value: "$\(coin.allTimeHigh.price)")
            statRow(label: "Change (24h)", value: "\(coin.change)%")
            statRow(label: "Rank", value: "#\(coin.rank)")
            statRow(label: "Supply", value: "Circulating: \(coin.supply?.circulating ?? ""), Max: \(coin.supply?.max ?? "0")")
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
