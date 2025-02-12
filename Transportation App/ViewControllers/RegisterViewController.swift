//
//  RegisterViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit
import FirebaseAuth
final class RegisterViewController: UIViewController {
    
    private let registerView = RegisterView()
    private let viewModel = AuthViewModel()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    private func setupUI() {
        title = "Register"
        navigationController?.navigationBar.tintColor = .black
        registerView.registerButton.addTarget(self, 
                                           action: #selector(handleRegister), 
                                           for: .touchUpInside)
    }
    
    private func setupDelegates() {
        registerView.emailTextField.delegate = self
        registerView.passwordTextField.delegate = self
        registerView.fullNameTextField.delegate = self
    }
    
    @objc private func handleRegister() {
        guard let email = registerView.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty,
              let password = registerView.passwordTextField.text,
              !password.isEmpty,
              let fullName = registerView.fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Error", message: "Please enter a valid email")
            return
        }
        
        if password.count < 6 {
            showAlert(title: "Error", message: "Password must be at least 6 characters")
            return
        }
        
        view.isUserInteractionEnabled = false
        registerView.registerButton.setTitle("Registering...", for: .normal)
        
        viewModel.signUp(email: email, password: password, fullName: fullName) { [weak self] result in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                self?.registerView.registerButton.setTitle("Sign Up", for: .normal)
                
                switch result {
                case .success(let user):
                    self?.viewModel.retryUserDataSave(user: user) { error in
                        if let error = error {
                            self?.showAlert(title: "Warning", 
                                          message: "Account created but some data couldn't be saved. Please try logging out and back in.") {
                                self?.navigateToProfile(with: user)
                            }
                        } else {
                            self?.showAlert(title: "Success", 
                                          message: "Registration successful!") {
                                self?.navigateToProfile(with: user)
                            }
                        }
                    }
                case .failure(let error):
                    let errorMessage = self?.handleFirebaseError(error) ?? error.localizedDescription
                    self?.showAlert(title: "Error", message: errorMessage)
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func handleFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already in use"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email"
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is weak"
        case AuthErrorCode.networkError.rawValue:
            return "The internet connection appears to be offline"
        default:
            return "Error: \(error.localizedDescription)"
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                     message: message,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    private func navigateToProfile(with user: User) {
        let homeVC = HomeViewController(user: user)
        
        let profileVC = ProfileViewController(user: user)
        
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(profileVC, animated: false)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @objc private func handleBack() {
        dismiss(animated: true)
    }
    
    @objc private func handleHome() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case registerView.fullNameTextField:
            registerView.emailTextField.becomeFirstResponder()
        case registerView.emailTextField:
            registerView.passwordTextField.becomeFirstResponder()
        case registerView.passwordTextField:
            textField.resignFirstResponder()
            handleRegister()
        default:
            break
        }
        return true
    }
} 
