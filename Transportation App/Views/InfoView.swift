//
//  InfoView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 22.02.2025.
//


import UIKit

final class InfoView: UIView {
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
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(infoCardView)
        infoCardView.addSubview(descriptionLabel)
        
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
            
            infoCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -20)
        ])
        
        infoCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
    }
    
    func configure(with viewModel: InfoViewModel) {
        descriptionLabel.text = viewModel.appDescription
    }
} 
