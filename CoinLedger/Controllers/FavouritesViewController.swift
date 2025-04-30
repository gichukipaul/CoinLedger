//
//  FavouritesViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    private let viewModel = FavouritesViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Coins"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavourites()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.favouriteCoins.isEmpty {
            tableView.setEmptyMessage("No coins Favourited.")
        } else {
            tableView.restore()
        }
        return viewModel.favouriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
        let coin = viewModel.favouriteCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavouriteAction = UIContextualAction(style: .destructive, title: "Unfavourite") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.viewModel.removeFavourite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [unfavouriteAction])
    }
}
