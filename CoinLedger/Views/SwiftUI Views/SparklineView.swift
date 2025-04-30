//
//  SparklineView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import SwiftUI
import Charts

struct SparklineView: View {
    var points: [Double]
    var isPositive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = points.max() ?? 1
            let minValue = points.min() ?? 0
            let height = geometry.size.height
            let width = geometry.size.width
            
            // Scale the points to fit into the container
            let scaledPoints = points.map { point in
                return height - CGFloat((point - minValue) / (maxValue - minValue) * Double(height))
            }
            
            // Create the path
            Path { path in
                path.move(to: CGPoint(x: 0, y: scaledPoints[0]))
                for index in 1..<scaledPoints.count {
                    path.addLine(to: CGPoint(x: CGFloat(index) / CGFloat(points.count - 1) * width, y: scaledPoints[index]))
                }
            }
            .stroke(isPositive ? Color.green : Color.red, lineWidth: 2)
            .background(
                LinearGradient(gradient: Gradient(colors: [isPositive ? Color.green.opacity(0.05) : Color.red.opacity(0.05), Color.clear]), startPoint: .top, endPoint: .bottom)
            )
        }
        .frame(height: 40)
    }
}

#Preview {
    SparklineView(points: [0.2,3.0,5.0], isPositive: true)
}
