//
//  FavouriteCoinsStorage.swift
//  CoinLedger
//
//  Created by GICHUKI on 30/04/2025.
//

import Foundation
import CoreData

final class FavouriteCoinStorage {
    static let shared = FavouriteCoinStorage()
    private let context = CoreDataManager.shared.context

    func save(_ coin: Coin) {
        guard !isCoinFavourited(uuid: coin.uuid) else { return }
        let Favourite = FavouriteCoin(context: context)
        Favourite.uuid = coin.uuid
        Favourite.name = coin.name
        Favourite.symbol = coin.symbol
        Favourite.iconURL = coin.iconURL
        Favourite.price = coin.price
        CoreDataManager.shared.saveContext()
    }

    func remove(_ coin: Coin) {
        removeByUUID(coin.uuid)
    }

    func removeByUUID(_ uuid: String) {
        let fetch: NSFetchRequest<FavouriteCoin> = FavouriteCoin.fetchRequest()
        fetch.predicate = NSPredicate(format: "uuid == %@", uuid)
        if let result = try? context.fetch(fetch), let object = result.first {
            context.delete(object)
            CoreDataManager.shared.saveContext()
        }
    }

    func isCoinFavourited(uuid: String) -> Bool {
        let fetch: NSFetchRequest<FavouriteCoin> = FavouriteCoin.fetchRequest()
        fetch.predicate = NSPredicate(format: "uuid == %@", uuid)
        return (try? context.count(for: fetch)) ?? 0 > 0
    }

    func fetchFavourites() -> [FavouriteCoin] {
        (try? context.fetch(FavouriteCoin.fetchRequest())) ?? []
    }
}

