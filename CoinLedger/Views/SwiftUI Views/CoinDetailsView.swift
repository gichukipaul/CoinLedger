//
//  CoinDetailsView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import SwiftUI

enum ChartType: String, CaseIterable, Identifiable {
    case line = "Line Chart"
    case bar = "Bar Chart"
    case area = "Area Chart"
    var id: String { self.rawValue }
}

struct CoinDetailsView: View {
    @StateObject var viewModel: CoinDetailsViewModel
    @State private var selectedChartType: ChartType = .line
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let coin = viewModel.coinDetails {
                ScrollView {
                    VStack(spacing: 20) {
                        CoinHeaderView(coin: coin)
                        
                        ChartSelectorView(selectedChartType: $selectedChartType, coin: coin)
                        
                        CoinStatsView(coin: coin)
                        
                        CoinDescriptionView(coin: coin)
                        
                        CoinLinksView(coin: coin)
                    }
                    .padding(.bottom)
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .task {
            await viewModel.fetchDetails()
        }
        .navigationTitle("\(viewModel.coinDetails?.name ?? "Coin") Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CoinDetailsView(viewModel: CoinDetailsViewModel(uuid: "Qwsogvtv82FCd"))
}
