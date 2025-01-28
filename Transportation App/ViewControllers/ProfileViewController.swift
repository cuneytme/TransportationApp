//
//  ProfileViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit


final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private let viewModel: ProfileViewModel
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        updateUI()
    }
    
    private func setupUI() {
        view.addSubview(profileView)
        profileView.frame = view.bounds
    }
    
    private func setupBindings() {
        profileView.logoutButton.addTarget(self, 
                                         action: #selector(handleLogout), 
                                         for: .touchUpInside)
        
        viewModel.didLogout = { [weak self] in
            let loginVC = LoginViewController(viewModel: AuthViewModel())
            loginVC.modalPresentationStyle = .fullScreen
          
            UIApplication.shared.windows.first?.rootViewController = loginVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func updateUI() {
        profileView.nameLabel.text = viewModel.fullName
        profileView.emailLabel.text = viewModel.email
    }
    
    @objc private func handleLogout() {
        viewModel.logout()
    }
} 
