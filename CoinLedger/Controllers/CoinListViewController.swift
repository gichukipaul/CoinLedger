//
//  CoinListViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit

final class CoinListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No coins available"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.isHidden = true
        return label
    }()
    
    // MARK: - ViewModel
    private let viewModel = CoinListViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchInitialCoins()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Top Coins"
        view.backgroundColor = .systemBackground
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchInitialCoins() {
        Task {
            await viewModel.refreshCoins()
            updateUI()
        }
    }
    
    private func updateUI() {
        noDataLabel.isHidden = !viewModel.coins.isEmpty
        tableView.reloadData()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count + (viewModel.isLoading ? 1 : 0) // Add one more row for the spinner
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If it's the last row and we're fetching more, show the spinner
        if indexPath.row == viewModel.coins.count {
            let spinnerCell = UITableViewCell()
            spinnerCell.selectionStyle = .none
            spinnerCell.contentView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            return spinnerCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.coins[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        // Trigger load more when scrolled to the bottom
        if offsetY > contentHeight - scrollView.frame.height * 1.5 {
            // Avoid multiple simultaneous fetch requests
            if !viewModel.isLoading, let last = viewModel.coins.last {
                Task {
                    await viewModel.loadMoreCoinsIfNeeded(currentItem: last)
                    tableView.reloadData()
                }
            }
        }
    }
}
