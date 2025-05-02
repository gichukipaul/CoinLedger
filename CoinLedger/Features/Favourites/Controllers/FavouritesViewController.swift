//
//  FavouritesViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit
import SwiftUI

final class FavouritesViewController: UIViewController {
    
    private let viewModel = FavouritesViewModel()
    private let tableView = UITableView()
    private let loadingView = LoadingStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Favourite Coins", comment: "Title for the favourites screen")
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingView.setState(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.loadFavourites()
            self.tableView.reloadData()
            
            if self.viewModel.favouriteCoins.isEmpty {
                self.loadingView.setState(.empty(message: NSLocalizedString("No coins favourited.", comment: "Message when no coins are favourited")))
            } else {
                self.loadingView.setState(.hidden)
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = viewModel.favouriteCoins[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = CoinDetailsViewModel(uuid: selectedCoin.uuid)
        let swiftUIView = CoinDetailsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavouriteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Unfavourite", comment: "Unfavourite button title")) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.viewModel.removeFavourite(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [unfavouriteAction])
    }
}
