//
//  AppTheme.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//


import UIKit

final class AppTheme {
    static let shared = AppTheme()
    
    private init() {}
    
    func configureNavigationBar(_ navigationController: UINavigationController?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appPrimary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.layer.cornerRadius = 15
        navigationController?.navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        navigationController?.navigationBar.layer.masksToBounds = false
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowRadius = 5
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureTabBar(_ tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appPrimary
        
        appearance.stackedLayoutAppearance.selected.iconColor = .buttonColor
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.layer.cornerRadius = 14
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.tintColor = .buttonColor
        tabBar.unselectedItemTintColor = .white
        
        if #available(iOS 13.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
} 
