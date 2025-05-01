//
//  LoadingStateView.swift
//  CoinLedger
//
//  Created by GICHUKI on 01/05/2025.
//

import UIKit

final class LoadingStateView: UIView {
    
    enum State {
        case loading
        case empty(message: String)
        case error(message: String, retryHandler: () -> Void)
        case hidden
    }
    
    // MARK: - UI Elements
    private let spinner = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private var retryAction: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        addSubview(spinner)
        addSubview(messageLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 12),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setState(_ state: State) {
        isHidden = false
        spinner.stopAnimating()
        messageLabel.text = nil
        retryButton.isHidden = true
        retryAction = nil
        
        switch state {
        case .loading:
            spinner.startAnimating()
            messageLabel.text = "Loading..."
        case .empty(let message):
            messageLabel.text = message
        case .error(let message, let retryHandler):
            messageLabel.text = message
            retryButton.isHidden = false
            retryAction = retryHandler
        case .hidden:
            isHidden = true
        }
    }
    
    @objc private func retryTapped() {
        retryAction?()
    }
}
