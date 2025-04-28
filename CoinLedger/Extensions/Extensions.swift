//
//  Extensions.swift
//  CoinLedger
//
//  Created by GICHUKI on 28/04/2025.
//

import Foundation

extension Bundle {
    var coinAPIKey: String? {
        guard let key = object(forInfoDictionaryKey: "coinAPIKey") as? String else {
            print("CoinAPIKey not found in Info.plist")
            return nil
        }
        return key
    }
}
