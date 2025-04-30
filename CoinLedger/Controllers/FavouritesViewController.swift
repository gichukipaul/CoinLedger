//
//  FavouritesViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit

final class FavouritesViewController: UITableViewController {

    private var Favourites: [FavouriteCoin] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Coins"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavouriteCoinCell")
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavourites()
    }

    private func loadFavourites() {
        Favourites = FavouriteCoinStorage.shared.fetchFavourites()
        tableView.reloadData()
    }

    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Favourites.isEmpty {
            tableView.setEmptyMessage("No coins Favourited.")
        } else {
            tableView.restore()
        }
        return Favourites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = Favourites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCoinCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "\(coin.name ?? "") (\(coin.symbol ?? ""))"
        content.secondaryText = "Price: \(coin.price ?? "-")"
        cell.contentConfiguration = content
        return cell
    }

    // Optional: support swipe-to-remove from Favourites in the Favourites screen
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = Favourites[indexPath.row]

        let action = UIContextualAction(style: .destructive, title: "UnFavourite") { [weak self] _, _, completion in
            guard let self else { return }
            if let uuid = coin.uuid {
                FavouriteCoinStorage.shared.removeByUUID(uuid)
                self.Favourites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
}

