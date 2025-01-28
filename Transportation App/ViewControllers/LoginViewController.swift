//
//  LoginViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import UIKit

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
        
        viewModel.didSignIn = { [weak self] user in
            let homeVC = HomeViewController(user: user)
            let navController = UINavigationController(rootViewController: homeVC)
            navController.modalPresentationStyle = .fullScreen
            self?.present(navController, animated: true)
        }
        
        viewModel.didError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func setupKeyboardHandling() {
     
        loginView.emailTextField.returnKeyType = .next
        loginView.passwordTextField.returnKeyType = .done
        
      
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    @objc private func handleLogin() {
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else { return }
        
        viewModel.signIn(email: email, password: password)
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
