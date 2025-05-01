//
//  CoinHeaderView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import SwiftUI

struct CoinHeaderView: View {
    let coin: CoinDetails
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: iconURLToPNG(from: coin.iconURL))) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(hex: coin.color))
                Text("$\(coin.price)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
