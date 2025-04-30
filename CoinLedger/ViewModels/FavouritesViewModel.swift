//
//  FavouritesViewModel.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import Foundation

final class FavouritesViewModel {
    private(set) var favouriteCoins: [Coin] = []
    
    func loadFavourites() {
        favouriteCoins = FavouriteCoinStorage.shared
            .fetchFavourites()
            .compactMap { $0.asCoin }
    }
    
    func removeFavourite(at index: Int) {
        let coin = favouriteCoins[index]
        FavouriteCoinStorage.shared.removeByUUID(coin.uuid)
        favouriteCoins.remove(at: index)
    }
}
