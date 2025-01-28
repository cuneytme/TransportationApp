//
//  SplashViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModel
    private let splashView: SplashView
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        self.splashView = SplashView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(splashView)
        splashView.frame = view.bounds
        setupBindings()
        viewModel.startSplashTimer()
    }
    
    private func setupBindings() {
        viewModel.navigateToLogin = { [weak self] in
            let viewController = LoginViewController(viewModel: AuthViewModel())
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true)
        }
    }
} 
