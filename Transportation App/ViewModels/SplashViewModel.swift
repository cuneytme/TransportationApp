//
//  SplashViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//
import UIKit


final class SplashViewModel {
    var navigateToLogin: (() -> Void)?
    
    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToLogin?()
        }
    }
} 
