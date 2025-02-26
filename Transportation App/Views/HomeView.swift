//
//  HomeView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import UIKit

extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

final class HomeView: UIView {
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "asis_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let registerCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap To Register Your Card", for: .normal)
        if let image = UIImage(named: "edinburgh-image")?.withAlpha(0.3) {
            button.setBackgroundImage(image, for: .normal)
        }
        button.setTitleColor(.buttonColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.buttonColor.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registeredCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.lineBreakMode = .byWordWrapping
        if let image = UIImage(named: "edinburgh-image") {
            let whiteOverlay = UIColor.white.withAlphaComponent(0.7)
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            if let context = UIGraphicsGetCurrentContext() {
                image.draw(in: CGRect(origin: .zero, size: image.size))
                context.setFillColor(whiteOverlay.cgColor)
                context.fill(CGRect(origin: .zero, size: image.size))
                if let overlaidImage = UIGraphicsGetImageFromCurrentImageContext() {
                    button.setBackgroundImage(overlaidImage, for: .normal)
                }
            }
            UIGraphicsEndImageContext()
        }
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.buttonColor.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
       
    
    let loadBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Balance", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let payWithQRButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay With QR", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        
        addSubview(logoImageView)
        addSubview(registerCardButton)
        addSubview(registeredCardButton)
        addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(loadBalanceButton)
        buttonStackView.addArrangedSubview(payWithQRButton)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 180),
            
            registerCardButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -10),
            registerCardButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registerCardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registerCardButton.heightAnchor.constraint(equalToConstant: 200),
            
            registeredCardButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -10),
            registeredCardButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registeredCardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registeredCardButton.heightAnchor.constraint(equalToConstant: 200),
            
            buttonStackView.topAnchor.constraint(equalTo: registerCardButton.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func updateCardReadStatus(isCardRead: Bool) {
      registerCardButton.isHidden = isCardRead
        registeredCardButton.isHidden = !isCardRead
        layoutIfNeeded()
    }
    
    func updateRegisteredCardInfo(_ info: String) {
      registeredCardButton.setTitle(info, for: .normal)
        registeredCardButton.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

    
    

