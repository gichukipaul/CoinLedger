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
        VStack(alignment: .center, spacing: 16) {
            Text("Statistics")
                .font(.title2)
                .bold()
                .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                statRow(label: "Market Cap", value: formattedCurrency(coin.marketCap))
                statRow(label: "24h Volume", value: formattedCurrency(coin.the24HVolume))
                statRow(label: "All-Time High", value: formattedCurrency(coin.allTimeHigh.price))
                statRow(label: "Change (24h)", value: formattedPercentage(coin.change))
                statRow(label: "Rank", value: "#\(coin.rank)")
                statRow(
                    label: "Supply",
                    value: "Circulating: \(formattedNumber(coin.supply?.circulating)), Max: \(formattedNumber(coin.supply?.max))"
                )
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func statRow(label: String, value: String) -> some View {
        if label == "Change (24h)", let change = Double(coin.change) {
            let isPositive = change >= 0
            let arrowName = isPositive ? "arrow.up" : "arrow.down"
            let color: Color = isPositive ? .green : .red
            let formatted = String(format: "%.2f%%", change)

            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: arrowName)
                    Text(formatted)
                }
                .foregroundColor(color)
            }
        } else {
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    private func formattedCurrency(_ string: String?) -> String {
        guard let string = string, let doubleValue = Double(string) else { return "--" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "--"
    }
    
    private func formattedPercentage(_ string: String?) -> String {
        guard let string = string, let value = Double(string) else { return "--" }
        return String(format: "%.2f%%", value)
    }
    
    private func formattedNumber(_ string: String?) -> String {
        guard let string = string, let doubleValue = Double(string) else { return "--" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "--"
    }
}
