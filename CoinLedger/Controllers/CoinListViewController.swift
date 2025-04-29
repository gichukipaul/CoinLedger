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
        tableView.rowHeight = 60
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
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        footerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = "You've reached the end of the free coin list."
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        return footerView
    }
    
    private func createLoadingFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        footerView.backgroundColor = .clear
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        footerView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        return footerView
    }
    
    private func showFooterView() {
        if viewModel.isLoading {
            tableView.tableFooterView = createLoadingFooter()
        } else if !viewModel.hasMoreCoins {
            UIView.transition(with: tableView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                self?.tableView.tableFooterView = self?.createFooterView()
            })
        } else {
            tableView.tableFooterView = nil
        }
    }
    
    
    private func fetchInitialCoins() {
        Task {
            await viewModel.refreshCoins()
            await MainActor.run {
                self.updateUI()
                self.showFooterView()
            }
        }
    }
    
    private func updateUI() {
        noDataLabel.isHidden = !viewModel.coins.isEmpty
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.showFooterView()
        }
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
        return viewModel.coins.count
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
        let threshold = scrollView.frame.height * 1.5
        
        // Trigger load more when approaching the bottom
        guard offsetY > contentHeight - threshold,
              !viewModel.isLoading,
              !Task.isCancelled,
              viewModel.hasMoreCoins,
              let lastCoin = viewModel.coins.last else { return }
        
        // Use detached task to prevent retain cycles and main-thread blocking
        Task.detached(priority: .userInitiated) { [self] in
            await viewModel.loadMoreCoinsIfNeeded(currentItem: lastCoin)
            await MainActor.run {
                self.tableView.reloadData()
                self.showFooterView()
            }
        }
    }
}
