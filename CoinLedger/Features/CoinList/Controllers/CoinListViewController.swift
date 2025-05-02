//
//  CoinListViewController.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit
import SwiftUI

final class CoinListViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingView = LoadingStateView()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No coins available"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.isHidden = true
        return label
    }()
    
    private let filterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["None", "Highest Price", "Best 24h"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(filterSegmentedControl)
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(noDataLabel)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
    
    @objc private func filterChanged() {
            let selectedOption: CoinListSortOption
            switch filterSegmentedControl.selectedSegmentIndex {
            case 1:
                selectedOption = .highestPrice
            case 2:
                selectedOption = .best24hPerformance
            default:
                selectedOption = .none
            }
            
            Task {
                await viewModel.setSortOption(selectedOption)
                await MainActor.run {
                    self.tableView.reloadData()
                    self.showFooterView()
                }
            }
        }
        
        private func fetchInitialCoins() {
            loadingView.setState(.loading)
            tableView.isUserInteractionEnabled = false
            
            Task {
                await viewModel.refreshCoins()
                await MainActor.run {
                    tableView.isUserInteractionEnabled = true
                    tableView.reloadData()
                    showFooterView()
                    
                    if let error = viewModel.errorMessage, viewModel.coins.isEmpty {
                        loadingView.setState(.error(message: error) { [weak self] in
                            self?.fetchInitialCoins()
                        })
                    } else if viewModel.coins.isEmpty {
                        loadingView.setState(.empty(message: "No coins available"))
                    } else {
                        loadingView.setState(.hidden)
                    }
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
    
    private func addRetryButton() {
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func retryTapped() {
        fetchInitialCoins()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = viewModel.coins[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = CoinDetailsViewModel(uuid: selectedCoin.uuid)
        let swiftUIView = CoinDetailsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = viewModel.coins[indexPath.row]
        let isFavourited = FavouriteCoinStorage.shared.isCoinFavourited(uuid: coin.uuid)
        
        let action = UIContextualAction(style: .normal, title: isFavourited ? "UnFavourite" : "Favourite") { [weak self] _, _, completion in
            if isFavourited {
                FavouriteCoinStorage.shared.remove(coin)
            } else {
                FavouriteCoinStorage.shared.save(coin)
            }
            completion(true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = isFavourited ? .systemRed : .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
