//
//  ChartSelectorView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//


import SwiftUI
import Charts

struct ChartSelectorView: View {
    @Binding var selectedChartType: ChartType
    let coin: CoinDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Chart Type", selection: $selectedChartType) {
                ForEach(ChartType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
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
        }
    }
}
