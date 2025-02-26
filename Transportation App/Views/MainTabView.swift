//
//  MainTabView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//




import UIKit

final class MainTabView: UIView {
    let navigationBar: UINavigationBar = {
        let navbar = UINavigationBar()
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.layer.cornerRadius = 15
        navbar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        navbar.layer.masksToBounds = false
        navbar.layer.shadowColor = UIColor.black.cgColor
        navbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navbar.layer.shadowRadius = 5
        navbar.layer.shadowOpacity = 0.3
        return navbar
    }()
    
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        tabBar.backgroundColor = .appPrimary
        tabBar.tintColor = .buttonColor
        tabBar.unselectedItemTintColor = .white
        return tabBar
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        addSubview(tabBar)
        addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            
            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: navigationBar.topAnchor),
            
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
} 
