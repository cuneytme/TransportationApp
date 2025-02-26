//
//  LoadBalanceView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 22.02.2025.
//


import UIKit

final class LoadBalanceView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Load Balance"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Credit Card Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let expiryDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Expiry Date (MM/YY)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let cvvTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "CVV"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Amount to Load (£)"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let loadBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Load Balance", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
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
        backgroundColor = .systemBackground
        
        cardNumberTextField.delegate = self
        expiryDateTextField.delegate = self
        cvvTextField.delegate = self
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        addSubview(headerView)
        headerView.addSubview(headerLabel)
        addSubview(stackView)
        
        [cardNumberTextField, expiryDateTextField, cvvTextField, amountTextField, loadBalanceButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
} 
