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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkAuthStatus()
        }
    }
    
    func checkAuthStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            print("Current user ID: \(firebaseUser.uid)")
            
            authViewModel.fetchUserData(userId: firebaseUser.uid) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.navigateToHome?(user)
                    }
                case .failure(let error):
                  
                    let basicUser = User(id: firebaseUser.uid,
                                      email: firebaseUser.email ?? "",
                                      fullName: "")
                    DispatchQueue.main.async {
                        self?.navigateToHome?(basicUser)
                    }
                }
            }
        } else {
            navigateToLogin?()
        }
    }
}
