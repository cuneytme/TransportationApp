//
//  PayWithQRView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//


import UIKit

final class PayWithQRView: UIView {
    private let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "qr")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let paidButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Paid", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(qrImageView)
        addSubview(paidButton)
        
        NSLayoutConstraint.activate([
            qrImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            qrImageView.widthAnchor.constraint(equalToConstant: 250),
            qrImageView.heightAnchor.constraint(equalToConstant: 250),
            
            paidButton.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 30),
            paidButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            paidButton.widthAnchor.constraint(equalToConstant: 200),
            paidButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
} 
