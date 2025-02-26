//
//  ServiceInfoView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//



import UIKit

final class ServiceInfoView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dismissCallback: (() -> Void)?
    
    let showServiceStopsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Service Stops", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let showTimetableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Service Timetable", for: .normal)
        button.backgroundColor = .appPrimary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(containerView)
        containerView.addSubview(showServiceStopsButton)
        containerView.addSubview(showTimetableButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            showServiceStopsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            showServiceStopsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            showServiceStopsButton.widthAnchor.constraint(equalToConstant: 250),
            showServiceStopsButton.heightAnchor.constraint(equalToConstant: 50),
            
            showTimetableButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            showTimetableButton.topAnchor.constraint(equalTo: showServiceStopsButton.bottomAnchor, constant: 20),
            showTimetableButton.widthAnchor.constraint(equalToConstant: 250),
            showTimetableButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if !containerView.frame.contains(location) {
            dismissCallback?()
        }
    }
}
