//
//  CoinCell.swift
//  CoinLedger
//
//  Created by GICHUKI on 29/04/2025.
//

import UIKit
import SwiftUI

final class CoinCell: UITableViewCell {
    
    // MARK: - Identifier
    static let identifier = "CoinCell"
    
    // MARK: - Subviews
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sparklineContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(changeLabel)
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(priceLabel)
        contentView.addSubview(verticalStack)
        contentView.addSubview(sparklineContainerView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),

            verticalStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: sparklineContainerView.leadingAnchor, constant: -8),

            sparklineContainerView.trailingAnchor.constraint(equalTo: changeLabel.leadingAnchor),
            sparklineContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sparklineContainerView.widthAnchor.constraint(equalToConstant: 100),
            sparklineContainerView.heightAnchor.constraint(equalToConstant: 60),

            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            changeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            changeLabel.widthAnchor.constraint(equalToConstant: 80)
        ])

    }
    
    
    // MARK: - Configure
    func configure(with coin: Coin) {
        nameLabel.text = coin.name
        priceLabel.text = "$\(coin.price.formatAsCurrency())"
        
        // 24h change
        if let change = Double(coin.change) {
            let formatted = String(format: "%.2f%%", change)
            changeLabel.text = formatted
            changeLabel.textColor = change >= 0 ? .systemGreen : .systemRed
        } else {
            changeLabel.text = "-"
            changeLabel.textColor = .secondaryLabel
        }
        
        // Download icon
        iconImageView.image = nil
        let pngURLString = iconURLToPNG(from: coin.iconURL)
        ImageLoader.shared.loadImage(from: pngURLString) { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        }
        
        // Sparkline Chart
        let values = coin.sparkline.compactMap { Double($0 ?? "") }
        if !values.isEmpty {
            let isPositive = (Double(coin.change) ?? 0) >= 0
            let hosting = UIHostingController(rootView: SparklineView(points: values, isPositive: isPositive))
            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            
            sparklineContainerView.subviews.forEach { $0.removeFromSuperview() }
            sparklineContainerView.addSubview(hosting.view)
            
            NSLayoutConstraint.activate([
                hosting.view.topAnchor.constraint(equalTo: sparklineContainerView.topAnchor),
                hosting.view.bottomAnchor.constraint(equalTo: sparklineContainerView.bottomAnchor),
                hosting.view.leadingAnchor.constraint(equalTo: sparklineContainerView.leadingAnchor),
                hosting.view.trailingAnchor.constraint(equalTo: sparklineContainerView.trailingAnchor),
            ])
        }
    }
}
