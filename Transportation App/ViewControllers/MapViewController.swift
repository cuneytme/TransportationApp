//
//  MapViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import MapKit
import UIKit
import CoreLocation
import Combine

final class MapViewController: UIViewController {
    private let mapView = MKMapView()
    private let viewModel: MapViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.startLiveUpdates()
    }
    
    private func setupUI() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        let edinburghCenter = CLLocationCoordinate2D(latitude: 55.9533, longitude: -3.1883)
        let region = MKCoordinateRegion(center: edinburghCenter,
                                      latitudinalMeters: 5000,
                                      longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupBindings() {
        viewModel.$stops
            .sink { [weak self] stops in
                self?.updateStopAnnotations(stops)
            }
            .store(in: &cancellables)
        
        viewModel.$vehicles
            .sink { [weak self] vehicles in
                self?.updateVehicleAnnotations(vehicles)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { error in error }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    private func updateStopAnnotations(_ stops: [Stop]) {
     
        let existingStopAnnotations = mapView.annotations.filter { $0 is StopAnnotation }
        mapView.removeAnnotations(existingStopAnnotations)
        
        let annotations = stops.map { stop in
            let annotation = StopAnnotation(stop: stop)
            annotation.coordinate = CLLocationCoordinate2D(latitude: stop.latitude,
                                                         longitude: stop.longitude)
            annotation.title = stop.name
            annotation.subtitle = "Stop ID: \(stop.stopId)"
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func updateVehicleAnnotations(_ vehicles: [Vehicle]) {
  
        let existingVehicleAnnotations = mapView.annotations.filter { $0 is VehicleAnnotation }
        mapView.removeAnnotations(existingVehicleAnnotations)
        
        let annotations = vehicles.map { vehicle in
            let annotation = VehicleAnnotation(vehicle: vehicle)
            annotation.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude,
                                                         longitude: vehicle.longitude)
            annotation.title = "Bus \(vehicle.serviceName)"
            annotation.subtitle = "To: \(vehicle.destination)"
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error",
                                    message: error,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D)
}

