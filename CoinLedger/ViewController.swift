//
//  ViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 26/04/2025.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        
        Task {
            await fetchCoins()
            await fetchingCoinDetails()
        }
    }
    
    private func fetchCoins() async {
        do {
            let service = CoinService()
            
            let coinsresponse = try await service.fetchCoins(limit: 20, offset: 0)
            print("Fetch successfully: \(coinsresponse)")
            DispatchQueue.main.async {
                self.view.backgroundColor = .systemGreen
            }
        } catch {
            print("fails: failliya failliya")
            DispatchQueue.main.async {
                self.view.backgroundColor = .systemRed
            }
        }
    }
    
    private func fetchingCoinDetails() async {
        do {
            let service = CoinService()
            // I want to test with Bitcoin's UUID is "Qwsogvtv82FCd"
            let coinDetailsResponse = try await service.fetchCoinDetails(uuid: "Qwsogvtv82FCd")
            
            print("Successfully fetched coin details: \(coinDetailsResponse)")
            
            DispatchQueue.main.async {
                self.view.backgroundColor = .cyan
            }
        } catch {
            print("Failed to fetch coin details: \(error)")
            
            DispatchQueue.main.async {
                self.view.backgroundColor = .orange
            }
        }
    }
}

