//
//  MainTabBarController.swift
//  CoinLedger
//
//  Created by GICHUKI on 26/04/2025.
//

import UIKit
final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        
        tabBar.tintColor = .systemBlue
            tabBar.barTintColor = .systemBackground
            tabBar.isTranslucent = false
    }

    private func setupTabs() {
        let coinListVC = CoinListViewController()
        let coinListNav = UINavigationController(rootViewController: coinListVC)
        coinListNav.tabBarItem = UITabBarItem(title: "Coins", image: UIImage(systemName: "bitcoinsign.circle"), tag: 0)

        let FavouritesVC = FavouritesViewController()
        let FavouritesNav = UINavigationController(rootViewController: FavouritesVC)
        FavouritesNav.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star"), tag: 1)

        viewControllers = [coinListNav, FavouritesNav]
    }
}


