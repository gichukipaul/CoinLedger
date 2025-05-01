//
//  CoinDescriptionView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//


import SwiftUI
import Charts

struct CoinDescriptionView: View {
    let coin: CoinDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About \(coin.name)")
                .font(.headline)
            Text(coin.description ?? "")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}