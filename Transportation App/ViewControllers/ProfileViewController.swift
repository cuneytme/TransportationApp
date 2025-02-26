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
    private let viewModel: ProfileViewModel
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        title = "Profile"
        
        DispatchQueue.main.async { [weak self] in
            self?.updateUIWithUserData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithUserData()
    }
    
    private func setupUI() {
        profileView.configure(with: viewModel.userInfo)
    }
    
    private func updateUI(with user: User) {
        profileView.nameLabel.text = user.fullName
        profileView.emailLabel.text = user.email
    }
    
    private func setupBindings() {
        profileView.logoutButton.addTarget(self, 
                                         action: #selector(handleLogout), 
                                         for: .touchUpInside)
        
        profileView.deleteCardButton.addTarget(self,
                                             action: #selector(handleDeleteCard),
                                             for: .touchUpInside)
        
        profileView.titleButton.addTarget(self,
                                        action: #selector(handleTitleSelection),
                                        for: .touchUpInside)
        
        viewModel.didLogout = { [weak self] in
            DispatchQueue.main.async {
                let authViewModel = AuthViewModel()
                let loginVC = LoginViewController(viewModel: authViewModel)
                let navigationController = UINavigationController(rootViewController: loginVC)
                navigationController.modalPresentationStyle = .fullScreen
                
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    UIView.transition(with: window,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: {
                        window.rootViewController = navigationController
                    })
                }
            }
        }
        
        viewModel.didUpdateUser = { [weak self] updatedUser in
            DispatchQueue.main.async {
                self?.profileView.configure(with: updatedUser)
            }
        }
        
        viewModel.didDeleteCard = { [weak self] in
            DispatchQueue.main.async {
                self?.showDeleteSuccessAlert()
            }
        }
        
        viewModel.didError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: errorMessage)
            }
        }
        
        viewModel.didUpdateTitle = { [weak self] title in
            DispatchQueue.main.async {
                self?.profileView.titleButton.setTitle(title, for: .normal)
            }
        }
    }
    
    private func updateUIWithUserData() {
        let userInfo = viewModel.userInfo
        profileView.configure(with: userInfo)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleLogout() {
        viewModel.logout()
    }
    
    @objc private func handleDeleteCard() {
        let alert = UIAlertController(
            title: "Delete Card",
            message: "Are you sure you want to delete your card?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCard()
        })
        
        present(alert, animated: true)
    }
    
    private func showDeleteSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "Your card has been deleted successfully",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleTitleSelection() {
        let alertController = UIAlertController(title: "Select Title",
                                              message: nil,
                                              preferredStyle: .actionSheet)
        
        viewModel.availableTitles.forEach { title in
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.viewModel.updateTitle(title)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = profileView.titleButton
            popoverController.sourceRect = profileView.titleButton.bounds
        }
        
        present(alertController, animated: true)
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
