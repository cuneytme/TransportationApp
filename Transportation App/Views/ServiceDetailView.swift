//
//  ServiceDetailView.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import UIKit
import MapKit

final class ServiceDetailView: UIView {
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let directionControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemBackground
        control.selectedSegmentTintColor = .systemBlue
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        return control
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
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
        addSubview(mapView)
        addSubview(directionControl)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            directionControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            directionControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            directionControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            mapView.topAnchor.constraint(equalTo: directionControl.bottomAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
} 
