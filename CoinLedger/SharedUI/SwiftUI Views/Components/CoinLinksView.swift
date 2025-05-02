//
//  CoinLinksView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//


import SwiftUI

struct CoinLinksView: View {
    let coin: CoinDetails
    
    var body: some View {
        if !coin.links.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Resources")
                    .font(.headline)
                
                ForEach(coin.links.compactMap { link -> (name: String, url: URL)? in
                    guard let url = URL(string: link.url) else { return nil }
                    return (link.name, url)
                }, id: \.url) { link in
                    Link(destination: link.url) {
                        HStack(alignment: .center, spacing: 6) {
                            Image(systemName: "link")
                            Text(link.name)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
