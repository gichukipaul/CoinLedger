//
//  Viewmodels+helpers.swift
//  CoinLedger
//
//  Created by GICHUKI on 02/05/2025.
//

import Foundation

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
