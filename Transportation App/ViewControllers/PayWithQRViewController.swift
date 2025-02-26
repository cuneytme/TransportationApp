//
//  PayWithQRViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import UIKit

final class PayWithQRViewController: UIViewController {
    private let payWithQRView = PayWithQRView()
    private let viewModel: PayWithQRViewModel
    
    init(user: User) {
        self.viewModel = PayWithQRViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = payWithQRView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        payWithQRView.paidButton.addTarget(self,
                                         action: #selector(handlePaidButton), 
                                         for: .touchUpInside)
        
        viewModel.didCompletePayment = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        } 
        
        viewModel.didReceiveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Error",
                    message: errorMessage,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default
                ))
                self?.present(alert, animated: true)
            }
        }
    }
    @objc private func handlePaidButton() {
        viewModel.processPayment()
    }
} 
