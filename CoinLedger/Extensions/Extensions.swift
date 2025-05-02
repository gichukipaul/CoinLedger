//
//  Extensions.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import UIKit
import SwiftUI

///Retrieve the API key stored in the Info.plist
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

/// This is for persisting in CoreData
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

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255
        
        self.init(red: red, green: green, blue: blue)
    }
    
    ///Sometimes the coin color is not legible when in dark or light mode
    ///In such a case, we reduce or increase the brightness accordingly. That way the content will be legible.
    func isTooCloseToBackground(for scheme: ColorScheme) -> Bool {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let brightness = (components[0] * 299 + components[1] * 587 + components[2] * 114) / 1000
        
        switch scheme {
        case .light:
            return brightness > 0.8
        case .dark:
            return brightness < 0.2
        @unknown default:
            return false
        }
    }
}
