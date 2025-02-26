//
//  ServiceCardCell.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit

final class ServiceCardCell: UITableViewCell {
    static let identifier = "ServiceCardCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let transportIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let serviceNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let firstStopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private let directionImageView: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white.withAlphaComponent(0.7)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let lastStopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .buttonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let transportContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let routeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.addSubview(mainStackView)
        cardView.addSubview(favoriteButton)
        
        mainStackView.addArrangedSubview(transportContainer)
        mainStackView.addArrangedSubview(routeStackView)
        
        transportContainer.addArrangedSubview(transportIconImageView)
        transportContainer.addArrangedSubview(serviceNumberLabel)
        
        routeStackView.addArrangedSubview(firstStopLabel)
        routeStackView.addArrangedSubview(directionImageView)
        routeStackView.addArrangedSubview(lastStopLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            favoriteButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            directionImageView.heightAnchor.constraint(equalToConstant: 16),
            
            transportContainer.widthAnchor.constraint(equalToConstant: 120),
            
            transportIconImageView.widthAnchor.constraint(equalToConstant: 64),
            transportIconImageView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func configure(with service: String, route: String?, isFavorite: Bool) {
        let components = service.components(separatedBy: " ")
        if components.count >= 2 {
            let serviceType = components[0]
            transportIconImageView.image = serviceType == "tram" ? 
                UIImage(named: "tram") : 
                UIImage(named: "service")
            serviceNumberLabel.text = components[1]
        }
        
        if let routeText = route {
            let stops = routeText.components(separatedBy: " ↔️ ")
            if stops.count == 2 {
                firstStopLabel.text = stops[0]
                lastStopLabel.text = stops[1]
            }
        }
        
        favoriteButton.isSelected = isFavorite
    }
} 
