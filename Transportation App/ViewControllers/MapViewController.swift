//
//  MapViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import MapKit
import UIKit
import CoreLocation

final class MapViewController: UIViewController, CLLocationManagerDelegate  {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
    }
    
    private func setupUI() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    private func setupLocationManager() {
       
        let fixedLocation = CLLocationCoordinate2D(latitude: 55.9500, longitude: -3.1900)
        let region = MKCoordinateRegion(
            center: fixedLocation,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = fixedLocation
        annotation.title = "Current Location"
        mapView.addAnnotation(annotation)
    }
}

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D)
}


