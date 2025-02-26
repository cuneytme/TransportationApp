//
//  TimelineView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//


import UIKit

final class TimetableCell: UITableViewCell {
    static let identifier = "TimetableCell"
    
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        cardView.addSubview(timeLabel)
        cardView.addSubview(destinationLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            timeLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            timeLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            destinationLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            destinationLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            destinationLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func configure(with time: String, destination: String) {
        timeLabel.text = time
        destinationLabel.text = destination
    }
} 
