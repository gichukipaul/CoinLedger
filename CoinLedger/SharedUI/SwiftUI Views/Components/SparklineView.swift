//
//  SparklineView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import SwiftUI

struct SparklineView: View {
    var points: [Double]
    var isPositive: Bool

    var body: some View {
        GeometryReader { geometry in
            let maxValue = points.max() ?? 1
            let minValue = points.min() ?? 0
            let height = geometry.size.height
            let width = geometry.size.width

            let scaledPoints = points.map { point in
                height - CGFloat((point - minValue) / (maxValue - minValue) * Double(height))
            }

            let baselineY: CGFloat? = {
                guard let baseline = points.first else { return nil }
                return height - CGFloat((baseline - minValue) / (maxValue - minValue) * Double(height))
            }()

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: scaledPoints[0]))
                    for index in 1..<scaledPoints.count {
                        path.addLine(to: CGPoint(x: CGFloat(index) / CGFloat(points.count - 1) * width, y: scaledPoints[index]))
                    }
                }
                .stroke(isPositive ? Color.green : Color.red, lineWidth: 2)

                if let y = baselineY {
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4]))
                }
            }
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
