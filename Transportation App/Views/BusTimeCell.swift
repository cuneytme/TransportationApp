//
//  BusTimeCell.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import UIKit

final class BusTimeCell: UITableViewCell {
    static let identifier = "BusTimeCell"
    
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
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let routeContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let routeNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .buttonColor
        label.textAlignment = .right
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .right
        return label
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
        
        mainStackView.addArrangedSubview(routeContainer)
        
        routeContainer.addArrangedSubview(routeNumberLabel)
        routeContainer.addArrangedSubview(destinationLabel)
        
        let timeContainer = UIStackView()
        timeContainer.axis = .vertical
        timeContainer.spacing = 4
        timeContainer.alignment = .trailing
        
        timeContainer.addArrangedSubview(timeLabel)
        timeContainer.addArrangedSubview(statusLabel)
        mainStackView.addArrangedSubview(timeContainer)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(routeName: String, destination: String, time: String, isLive: Bool) {
        routeNumberLabel.text = "\(routeName)"
        destinationLabel.text = destination
        timeLabel.text = time
        statusLabel.text = isLive ? "Live" : "Planned"
        statusLabel.textColor = isLive ? .buttonColor : .white.withAlphaComponent(0.8)
        
        let serviceImage = UIImage(named: "service")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = serviceImage
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 24, height: 24)
        
        let attributedString = NSMutableAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: " \(routeName)"))
        routeNumberLabel.attributedText = attributedString
    }
} 
