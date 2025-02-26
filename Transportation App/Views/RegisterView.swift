//
//  RegisterView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//

import UIKit


final class RegisterView: UIView {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "asis_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let formContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .buttonColor
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name Surname"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .none
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    let titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Title", for: .normal)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 8
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = true
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        
        addSubview(logoImageView)
        addSubview(formContainerView)
        formContainerView.addSubview(stackView)
        
        [fullNameTextField, emailTextField, titleButton, passwordTextField, registerButton].forEach { 
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 180),
            
            formContainerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            formContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            formContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: -20)
        ])
    }
} 
