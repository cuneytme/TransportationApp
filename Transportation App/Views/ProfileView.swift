//
//  ProfileView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit


final class ProfileView: UIView {
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .appPrimary
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.buttonColor.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.3
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Title", for: .normal)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Card", for: .normal)
        button.backgroundColor = .buttonColor
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [profileImageView, infoCardView, buttonStackView].forEach { contentView.addSubview($0) }
        
        [nameLabel, emailLabel, titleButton, cardNumberLabel].forEach { 
            infoCardView.addSubview($0)
        }
        
        [deleteCardButton, logoutButton].forEach { 
            buttonStackView.addArrangedSubview($0) 
        }
        
        deleteCardButton.backgroundColor = .buttonColor
        logoutButton.backgroundColor = .systemRed
        deleteCardButton.setTitleColor(.black, for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        deleteCardButton.layer.cornerRadius = 8
        logoutButton.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoCardView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            
            titleButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            titleButton.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            titleButton.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            titleButton.heightAnchor.constraint(equalToConstant: 44),
            
            cardNumberLabel.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 16),
            cardNumberLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            cardNumberLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            cardNumberLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -20),
            
            buttonStackView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            deleteCardButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        infoCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    func configure(with user: User) {
     
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.nameLabel.text = user.fullName
            self.emailLabel.text = user.email
            
            if user.title.isEmpty {
                self.titleButton.setTitle("Title information not entered", for: .normal)
            } else {
                self.titleButton.setTitle(user.title, for: .normal)
            }
            
            if let cardNumber = user.cardNumber {
                self.cardNumberLabel.text = "Card Number: \(cardNumber)"
                self.deleteCardButton.isHidden = false
            } else {
                self.cardNumberLabel.text = "No Card Registered"
                self.deleteCardButton.isHidden = true
            }
            
            self.infoCardView.setNeedsLayout()
            self.infoCardView.layoutIfNeeded()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
} 
