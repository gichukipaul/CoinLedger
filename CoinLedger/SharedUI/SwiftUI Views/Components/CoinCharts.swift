//
//  CoinCharts.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import SwiftUI
import Charts

struct LineChartView: View {
    let points: [Double]
    let isPositiveChange: Bool
    @State private var animate = false
    
    var body: some View {
        Chart {
            // Line data
            ForEach(points.indices, id: \.self) { index in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", points[index])
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isPositiveChange ? .green : .red)
                .opacity(animate ? 1 : 0.1)
            }
            
            // Baseline rule
            if let baseline = points.first {
                RuleMark(y: .value("Baseline", baseline))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.gray)
                    .opacity(0.5)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [isPositiveChange ? Color.green.opacity(0.1) : Color.red.opacity(0.1), Color.clear]),
                startPoint: .top, endPoint: .bottom
            )
        )
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXScale(domain: 0...(points.count - 1))
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatCount(2, autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct BarChartView: View {
    let volumes: [Double]
    let isPositiveChange: Bool
    @State private var animate = false
    
    var body: some View {
        Chart {
            ForEach(volumes.indices, id: \.self) { index in
                BarMark(
                    x: .value("Index", index),
                    y: .value("Volume", animate ? volumes[index] : 0)
                )
                .foregroundStyle(isPositiveChange ? .green : .red)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [isPositiveChange ? Color.green.opacity(0.1) : Color.red.opacity(0.1), Color.clear]), startPoint: .top, endPoint: .bottom)
        )
        .chartXScale(domain: 0...(volumes.count - 1))
        .chartYAxis { AxisMarks(position: .leading) }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatCount(1,autoreverses: false)) {
                animate = true
            }
        }
    }
}

struct AreaChartView: View {
    let volumes: [Double]
    let isPositiveChange: Bool
    @State private var animate = false
    
    var body: some View {
        Chart {
            ForEach(volumes.indices, id: \.self) { index in
                AreaMark(
                    x: .value("Index", index),
                    y: .value("Price", animate ? volumes[index] : 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: isPositiveChange ? Color.green.opacity(0.6) : Color.red.opacity(0.6), location: 0.0),
                            .init(color: isPositiveChange ? Color.green.opacity(0.3) : Color.red.opacity(0.3), location: 0.4),
                            .init(color: .clear, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            
            ForEach(volumes.indices, id: \.self) { index in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Price", animate ? volumes[index] : 0)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isPositiveChange ? .green : .red)
                .opacity(animate ? 0.8 : 0.2)
            }
            
            // Baseline rule
            if let baseline = volumes.first {
                RuleMark(y: .value("Baseline", baseline))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundStyle(.gray)
                    .opacity(0.5)
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXScale(domain: 0...(volumes.count - 1))
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatCount(1, autoreverses: false)) {
                animate = true
            }
        }
    }
}
