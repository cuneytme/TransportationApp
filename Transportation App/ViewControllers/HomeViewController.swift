//
//  HomeViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//
import UIKit

final class HomeViewController: UIViewController {
    
    private let user: User
    private let homeView = HomeView()
    private let viewModel: HomeViewModel
    
    init(user: User) {
        self.user = user
        self.viewModel = HomeViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupBindings() {
        homeView.registerCardButton.addTarget(self, 
                                            action: #selector(handleRegisterCard), 
                                            for: .touchUpInside)
        
        viewModel.didUpdateCardReadStatus = { [weak self] isCardRead in
            DispatchQueue.main.async {
                self?.homeView.updateCardReadStatus(isCardRead: isCardRead)
            }
        }
        
        viewModel.didUpdateRegisteredCardInfo = { [weak self] info in
            DispatchQueue.main.async {
                self?.homeView.updateRegisteredCardInfo(info)
            }
        }
        
        homeView.loadBalanceButton.addTarget(self, 
                                           action: #selector(handleLoadBalance), 
                                           for: .touchUpInside)
        
        homeView.payWithQRButton.addTarget(self, 
                                         action: #selector(handlePayWithQR), 
                                         for: .touchUpInside)
    }
    
    @objc private func handleRegisterCard() {
        viewModel.registerCard()
    }
    
    @objc private func handleLoadBalance() {
        viewModel.handleLoadBalanceTapped()
    }
    
    @objc private func handlePayWithQR() {
        viewModel.handlePayWithQRTapped()
    }
}
