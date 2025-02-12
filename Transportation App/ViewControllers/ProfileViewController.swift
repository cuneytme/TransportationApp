//
//  ProfileViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private var viewModel: ProfileViewModel
    
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
        setupNavigationBar()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userId = Auth.auth().currentUser?.uid {
            let authViewModel = AuthViewModel()
            authViewModel.fetchUserData(userId: userId) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.viewModel = ProfileViewModel(user: user)
                        self?.updateUI()
                    }
                case .failure(let error):
                    print("Error refreshing user data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(profileView)
        profileView.frame = view.bounds
    }
    
    private func setupBindings() {
        profileView.logoutButton.addTarget(self, 
                                         action: #selector(handleLogout), 
                                         for: .touchUpInside)
        
        profileView.registerCardButton.addTarget(self,
                                               action: #selector(handleRegisterCard),
                                               for: .touchUpInside)
        
        viewModel.didLogout = { [weak self] in
            let loginVC = LoginViewController(viewModel: AuthViewModel())
            loginVC.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController = loginVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    private func setupNavigationBar() {
        title = "Profile"
        
        if navigationItem.leftBarButtonItem == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleBack))
        }
        
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(handleHome))
        }
    }
    
    private func updateUI() {
        profileView.nameLabel.text = viewModel.fullName
        profileView.emailLabel.text = viewModel.email
    }
    
    @objc private func handleLogout() {
        viewModel.logout()
    }
    
    @objc private func handleRegisterCard() {
        
        
        // NFC READING WILL BE IMPLEMENTED HERE
        
       
    }
    
    @objc private func handleBack() {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func handleHome() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
} 
