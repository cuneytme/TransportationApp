//
//  TimelineView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 27.01.2025.
//


import UIKit

final class TimelineView: UIView {
    private let timeLabel: UILabel = {
        let label = UILabel()
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
        backgroundColor = .clear
        addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateTime(_ time: String) {
        timeLabel.text = time
    }
} 
