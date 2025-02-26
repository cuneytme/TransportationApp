//
//  CardHistoryViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//


import UIKit

final class CardHistoryViewController: UIViewController {
    private let cardHistoryView = CardHistoryView()
    private let viewModel: CardHistoryViewModel
    
    init(user: User) {
        self.viewModel = CardHistoryViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cardHistoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        cardHistoryView.tableView.delegate = self
        cardHistoryView.tableView.dataSource = self
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cardHistoryView.tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    private func setupBindings() {
        viewModel.didUpdateTransactions = { [self] _ in
            self.cardHistoryView.tableView.backgroundView = nil
            self.cardHistoryView.tableView.reloadData()
        }
        
        viewModel.didReceiveError = { [weak self] error in
            let label = UILabel()
            label.text = "Error loading transactions: \(error)"
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = .gray
            self?.cardHistoryView.tableView.backgroundView = label
        }
        
        viewModel.didUpdateCardInfo = { [weak self] cardInfo in
            self?.cardHistoryView.cardInfoLabel.text = cardInfo
        }
    }
    
    @objc private func handleClose() {
        dismiss(animated: true)
    }
}

extension CardHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTransactions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        
        let transaction = viewModel.transaction(at: indexPath.row)
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
} 
