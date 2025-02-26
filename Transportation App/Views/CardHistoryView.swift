//
//  CardHistoryView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import UIKit
final class CardHistoryView: UIView {
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorStyle = .singleLine
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(headerView)
        headerView.addSubview(cardInfoLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            cardInfoLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            cardInfoLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            cardInfoLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

final class TransactionCell: UITableViewCell {
    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .red
        return label
    }()
    
    private let transportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let infoStack = UIStackView(arrangedSubviews: [serviceLabel, dateLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [transportImageView, infoStack, amountLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            transportImageView.widthAnchor.constraint(equalToConstant: 30),
            transportImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with transaction: CardTransaction) {
        let imageName: String
        switch transaction.type {
        case "Load Balance":
            imageName = "credit-card"
        case "Tram":
            imageName = "tram"
        default:
            imageName = "service"
        }
        transportImageView.image = UIImage(named: imageName)
        
        if transaction.type == "Load Balance" {
            serviceLabel.text = transaction.type
            amountLabel.textColor = .systemGreen
            amountLabel.text = String(format: "+£%.2f", transaction.amount)
        } else {
            serviceLabel.text = "\(transaction.type) \(transaction.serviceNumber)"
            amountLabel.textColor = .systemRed
            amountLabel.text = String(format: "-£%.2f", transaction.amount)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: transaction.date)
    }
} 
