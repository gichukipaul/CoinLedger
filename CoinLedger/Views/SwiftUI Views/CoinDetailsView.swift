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
    @State private var selectedTimePeriod: String = "24h"
    
    // Available time periods for selection
    private let timePeriods = ["1h", "3h", "12h", "24h", "7d", "30d", "3m", "1y", "3y", "5y"]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let coin = viewModel.coinDetails {
                ScrollView {
                    VStack(spacing: 20) {
                        CoinHeaderView(coin: coin)
                        
                        // Chart Type Picker and Time Period Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Chart Type", selection: $selectedChartType) {
                                ForEach(ChartType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            
                            Picker("Time Period", selection: $selectedTimePeriod) {
                                ForEach(timePeriods, id: \.self) { period in
                                    Text(period).tag(period)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                            .onChange(of: selectedTimePeriod) { newValue in
                                Task {
                                    await viewModel.fetchDetails(timePeriod: newValue)
                                }
                            }
                        }
                        
                        // Chart rendering based on selected chart type
                        Group {
                            let isPositiveChange = (Double(coin.change) ?? 0) >= 0
                            
                            if selectedChartType == .line {
                                LineChartView(
                                    points: coin.sparkline.compactMap { Double($0 ?? "") },
                                    isPositiveChange: isPositiveChange
                                )
                            } else if selectedChartType == .bar {
                                BarChartView(
                                    volumes: coin.sparkline.compactMap { Double($0 ?? "") },
                                    isPositiveChange: isPositiveChange
                                )
                            } else {
                                AreaChartView(
                                    volumes: coin.sparkline.compactMap { Double($0 ?? "") },
                                    isPositiveChange: isPositiveChange
                                )
                            }
                        }
                        .frame(height: 240)
                        .animation(.easeInOut, value: selectedChartType)
                        .padding(.horizontal)
                        
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
            await viewModel.fetchDetails(timePeriod: selectedTimePeriod)
        }
        .navigationTitle("\(viewModel.coinDetails?.name ?? "Coin") Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    CoinDetailsView(viewModel: CoinDetailsViewModel(uuid: "Qwsogvtv82FCd"))
}
