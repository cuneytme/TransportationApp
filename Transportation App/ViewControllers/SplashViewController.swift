//
//  SplashViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let splashView = SplashView()
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.startSplashTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupBindings() {
        viewModel.navigateToLogin = { [weak self] in
            let authViewModel = AuthViewModel()
            let loginVC = LoginViewController(viewModel: authViewModel)
            loginVC.modalPresentationStyle = .fullScreen
            self?.present(loginVC, animated: true)
        }
        
        viewModel.navigateToHome = { [weak self] user in
            let tabBarController = MainTabBarController(user: user)
            tabBarController.modalPresentationStyle = .fullScreen
            self?.present(tabBarController, animated: true)
        }
    }
} 
