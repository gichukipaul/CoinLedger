//
//  CoinDetailsViewModel.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import Foundation

@MainActor
final class CoinDetailsViewModel: ObservableObject {
    @Published private(set) var coinDetails: CoinDetails?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let coinService: CoinService
    private let uuid: String
    
    init(uuid: String, coinService: CoinService = CoinService()) {
        self.uuid = uuid
        self.coinService = coinService
    }
    
    func fetchDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await coinService.fetchCoinDetails(uuid: uuid)
            self.coinDetails = response.data.coin
        } catch {
            errorMessage = "Failed to load details: \(error)"
            print("Error fetching details for \(uuid): \(error)")
        }
        
        isLoading = false
    }
}
