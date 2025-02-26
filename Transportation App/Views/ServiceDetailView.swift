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
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .appPrimary
        control.setTitleTextAttributes([.foregroundColor: UIColor.appPrimary], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.buttonColor], for: .selected)
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
        addSubview(activityIndicator)
        mapView.addSubview(directionControl)
        
       
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            directionControl.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
            directionControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            directionControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        directionControl.layer.cornerRadius = 8
        directionControl.layer.masksToBounds = true
        directionControl.backgroundColor = .white.withAlphaComponent(0.9)
        directionControl.layer.borderWidth = 1
        directionControl.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
