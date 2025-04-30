//
//  Extensions.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import UIKit

extension Bundle {
    var coinAPIKey: String? {
        guard let key = object(forInfoDictionaryKey: "coinAPIKey") as? String else {
            print("CoinAPIKey not found in Info.plist")
            return nil
        }
        return key
    }
}

extension String {
    func formatAsCurrency() -> String {
        guard let value = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? self
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        label.text = message
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        backgroundView = label
        separatorStyle = .none
    }
    
    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}

extension FavouriteCoin {
    var asCoin: Coin {
        Coin(
            uuid: uuid ?? "",
            symbol: symbol ?? "",
            name: name ?? "",
            color: color ?? "",
            iconURL: iconURL ?? "",
            marketCap: marketCap ?? "",
            price: price ?? "",
            listedAt: Int(listedAt),
            tier: Int(tier),
            change: change ?? "",
            rank: Int(rank),
            sparkline: [], // Not persisted in Core Data for now
            lowVolume: lowVolume,
            coinrankingURL: coinrankingURL ?? "",
            the24HVolume: the24HVolume ?? "",
            btcPrice: btcPrice ?? "",
            contractAddresses: [] // Not persisted in Core Data for now
        )
    }
}
