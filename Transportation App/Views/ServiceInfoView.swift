//
//  ServiceInfoView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//



import UIKit

final class ServiceInfoView: UIView {
    let showServiceStopsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Service Stops", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let serviceInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let showTimetableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Service Timetable", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
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
        backgroundColor = .white
        
        addSubview(serviceInfoLabel)
        addSubview(showServiceStopsButton)
        addSubview(showTimetableButton)
        
        NSLayoutConstraint.activate([
            serviceInfoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            serviceInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            serviceInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            showServiceStopsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showServiceStopsButton.topAnchor.constraint(equalTo: serviceInfoLabel.bottomAnchor, constant: 30),
            showServiceStopsButton.widthAnchor.constraint(equalToConstant: 250),
            showServiceStopsButton.heightAnchor.constraint(equalToConstant: 50),
            
            showTimetableButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showTimetableButton.topAnchor.constraint(equalTo: showServiceStopsButton.bottomAnchor, constant: 20),
            showTimetableButton.widthAnchor.constraint(equalToConstant: 250),
            showTimetableButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

