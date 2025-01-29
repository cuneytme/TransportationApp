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
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            let user = User(uid: firebaseUser.uid,
                          dictionary: [
                            "email": firebaseUser.email ?? "",
                            "fullName": firebaseUser.displayName ?? ""
                          ])
            navigateToHome?(user)
        } else {
            navigateToLogin?()
        }
    }
}
