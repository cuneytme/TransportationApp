//
//  MenuViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//



import UIKit

final class MenuViewModel {
    private let user: User
    
    var didSelectProfile: (() -> Void)?
    var didSelectInfo: (() -> Void)?
    var didRequestDismissMenu: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
    func handleProfileSelection() {
        didSelectProfile?()
    }
    
    func handleInfoSelection() {
        didSelectInfo?()
    }
    
    func handleDismissMenu() {
        didRequestDismissMenu?()
    }
    
    func getUser() -> User {
        return user
    }
} 
