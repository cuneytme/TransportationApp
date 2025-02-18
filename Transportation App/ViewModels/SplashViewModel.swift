//
//  SplashViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//
import UIKit
import FirebaseAuth

final class SplashViewModel {
    var navigateToLogin: (() -> Void)?
    var navigateToHome: ((User) -> Void)?
    
    private let authViewModel = AuthViewModel()
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            authViewModel.fetchUserData(userId: firebaseUser.uid) { [weak self] result in
                switch result {
                case .success(let user):
                    let tabBarController = MainTabBarController(user: user)
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                       let window = sceneDelegate.window,
                       let navigationController = window.rootViewController as? UINavigationController {
                        navigationController.setNavigationBarHidden(false, animated: true)
                        navigationController.setViewControllers([tabBarController], animated: true)
                    }
                case .failure:
                    let basicUser = User(id: firebaseUser.uid,
                                       email: firebaseUser.email ?? "",
                                       fullName: "")
                    let tabBarController = MainTabBarController(user: basicUser)
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                       let window = sceneDelegate.window,
                       let navigationController = window.rootViewController as? UINavigationController {
                        navigationController.setNavigationBarHidden(false, animated: true)
                        navigationController.setViewControllers([tabBarController], animated: true)
                    }
                }
            }
        } else {
            navigateToLogin?()
        }
    }
}
