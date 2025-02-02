//
//  HomeView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import UIKit

final class HomeView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Map", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Stops", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let servicesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Services", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "asis_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        [logoImageView, mapButton, stopsButton, servicesButton].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            mapButton.heightAnchor.constraint(equalToConstant: 50),
            stopsButton.heightAnchor.constraint(equalToConstant: 50),
            servicesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func mapButtonAction(_ target: Any?, action: Selector) {
        mapButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

    
    

