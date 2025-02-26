//
//  FavoriteCardCell.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import UIKit

final class FavoriteCardCell: UITableViewCell {
    static let identifier = "FavoriteCardCell"
    
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
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
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
    
    private let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let routeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let firstStopLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 1
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
        label.numberOfLines = 1
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .buttonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        transportContainer.addArrangedSubview(typeImageView)
        transportContainer.addArrangedSubview(nameLabel)
        
        routeStackView.addArrangedSubview(firstStopLabel)
        routeStackView.addArrangedSubview(directionImageView)
        routeStackView.addArrangedSubview(lastStopLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            mainStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            favoriteButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            transportContainer.widthAnchor.constraint(equalToConstant: 100),
            
            typeImageView.widthAnchor.constraint(equalToConstant: 64),
            typeImageView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        firstStopLabel.text = nil
        lastStopLabel.text = nil
        typeImageView.image = nil
        routeStackView.isHidden = true
    }
    
    func configure(with favorite: Favorite, firstStop: String?, lastStop: String?) {
        if favorite.type == .service {
            typeImageView.image = UIImage(named: "service")
            nameLabel.textAlignment = .left
            nameLabel.text = favorite.name
            
            if let firstStop = firstStop, let lastStop = lastStop {
                firstStopLabel.text = firstStop
                lastStopLabel.text = lastStop
                routeStackView.isHidden = false
            } else {
                routeStackView.isHidden = true
            }
        } else {
            typeImageView.image = UIImage(named: "stops")
            nameLabel.textAlignment = .center
            nameLabel.text = favorite.name
            routeStackView.isHidden = true
        }
    }
} 
