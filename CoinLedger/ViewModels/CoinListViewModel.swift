//
//  CoinListViewModel.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import Foundation

// MARK: - CoinListViewModel
/// The ViewModel responsible for handling the logic for displaying the list of coins.
@MainActor
final class CoinListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var coins: [Coin] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var hasMoreCoins: Bool = true
    
    // MARK: - Private Properties
    private(set) var isFetchingMore = false
    private let coinService: CoinService
    private var currentOffset: Int = 0
    private let pageSize: Int = 20
    private var sortOption: CoinListSortOption = .none
    
    // MARK: - Initialization
    init(coinService: CoinService = CoinService()) {
        self.coinService = coinService
    }
    
    // MARK: - Public Methods
    
    /// Refreshes the list by resetting pagination and fetching from scratch
    func refreshCoins(sortOption: CoinListSortOption? = nil) async {
        isLoading = true
        errorMessage = nil
        
        if let sortOption = sortOption {
            self.sortOption = sortOption
        }
        
        currentOffset = 0
        hasMoreCoins = true
        
        do {
            let response = try await coinService.fetchCoins(limit: pageSize, offset: currentOffset, sortOption: self.sortOption)
            coins = response.data.coins
            currentOffset = coins.count
            hasMoreCoins = coins.count == pageSize && currentOffset < 100
        } catch {
            self.errorMessage = ViewModelError.networkError.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Loads more coins for pagination when user scrolls to bottom
    func loadMoreCoinsIfNeeded(currentItem: Coin) async {
        guard !isLoading, hasMoreCoins else { return }
        
        // Check if we're close to the end of the list
        let index = coins.firstIndex(where: { $0.uuid == currentItem.uuid }) ?? 0
        if index >= coins.count - 2 {
            await loadMoreCoins()
        }
    }
    
    // MARK: - Private Methods
    
    /// Fetches the next page of coins with additional guard logic to prevent rapid calls
    private func loadMoreCoins() async {
        guard !isFetchingMore, hasMoreCoins, currentOffset < 80, coins.count < 80 else { return }
        
        isFetchingMore = true
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await coinService.fetchCoins(limit: pageSize, offset: currentOffset, sortOption: sortOption)
            
            coins.append(contentsOf: response.data.coins)
            currentOffset = coins.count
            
            // Update hasMoreCoins based on both response and offset limit
            hasMoreCoins = response.data.coins.count == pageSize && currentOffset < 80
        } catch {
            errorMessage = "Failed to load more coins: \(error.localizedDescription)"
        }
        
        isLoading = false
        isFetchingMore = false
    }
    
}

// MARK: - Error Handling

enum ViewModelError: LocalizedError {
    case networkError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .networkError: return "Network error occurred. Please try again."
        case .noData: return "No coins available."
        }
    }
}
