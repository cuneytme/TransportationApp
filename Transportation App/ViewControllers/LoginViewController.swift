//
//  LoginViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
 
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupBindings() {
        loginView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(handleShowRegister), for: .touchUpInside)
        
        viewModel.didLogin = { [weak self] user in
            DispatchQueue.main.async {
                let tabBarController = MainTabBarController(user: user)
                let navigationController = UINavigationController(rootViewController: tabBarController)
                navigationController.modalPresentationStyle = .fullScreen
                
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .appPrimary
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
                navigationController.navigationBar.compactAppearance = appearance
                navigationController.navigationBar.tintColor = .white
                
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
        
        viewModel.didFailLogin = { [weak self] error in
            self?.showAlert(title: "Error", message: error)
        }
    }
    
    private func setupKeyboardHandling() {
     
        loginView.emailTextField.returnKeyType = .next
        loginView.passwordTextField.returnKeyType = .done
        
      
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    @objc private func handleLogin() {
        guard let email = loginView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = loginView.passwordTextField.text,
              !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        viewModel.login(email: email, password: password)
    }
    
    @objc private func handleShowRegister() {
        let registerVC = RegisterViewController()
        present(registerVC, animated: true)
    }
    
    @objc private func handleTapOutside() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

private extension LoginViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, 
                                    message: message, 
                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
} 
