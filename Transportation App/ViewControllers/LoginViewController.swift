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
            let homeVC = HomeViewController(user: user)
            let navigationController = UINavigationController(rootViewController: homeVC)
            navigationController.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async {
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
        
        view.isUserInteractionEnabled = false
        loginView.loginButton.setTitle("Logging in...", for: .normal)
        
        viewModel.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                self?.loginView.loginButton.setTitle("Login", for: .normal)
                
                switch result {
                case .success(let user):
                    let homeVC = HomeViewController(user: user)
                    homeVC.modalPresentationStyle = .fullScreen
                    self?.present(homeVC, animated: true)
                    
                case .failure(let error):
                    let errorMessage = self?.handleFirebaseError(error) ?? error.localizedDescription
                    self?.showAlert(title: "Error", message: errorMessage)
                }
            }
        }
    }
    
    private func handleFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Invalid email or password"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email format"
        case AuthErrorCode.userNotFound.rawValue:
            return "User not found"
        default:
            return error.localizedDescription
        }
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
