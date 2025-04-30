//
//  FavouriteCoin+CoreDataProperties.swift
//  CoinLedger
//
//  Created by GICHUKI on 30/04/2025.
//
//

import Foundation
import CoreData


extension FavouriteCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCoin> {
        return NSFetchRequest<FavouriteCoin>(entityName: "FavouriteCoin")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var iconURL: String?
    @NSManaged public var marketCap: String?
    @NSManaged public var price: String?
    @NSManaged public var listedAt: Int64
    @NSManaged public var tier: Int64
    @NSManaged public var change: String?
    @NSManaged public var rank: Int64
    @NSManaged public var lowVolume: Bool
    @NSManaged public var coinrankingURL: String?
    @NSManaged public var the24HVolume: String?
    @NSManaged public var btcPrice: String?

}

extension FavouriteCoin : Identifiable {

}
