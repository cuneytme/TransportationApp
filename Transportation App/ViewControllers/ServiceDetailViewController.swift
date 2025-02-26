//
//  ServiceDetailViewController.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import UIKit
import MapKit
import Combine

final class ServiceDetailViewController: UIViewController {
    private let serviceDetailView = ServiceDetailView()
    private let viewModel: ServiceDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private enum AnnotationIdentifier {
        static let stop = "StopPin"
        static let vehicle = "VehiclePin"
    }
    
    init(serviceNumber: String) {
        self.viewModel = ServiceDetailViewModel(serviceNumber: serviceNumber)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = serviceDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupMapView()
        viewModel.fetchServiceDetails()
        viewModel.startLiveUpdates()
    }
    
    private func setupUI() {
        title = viewModel.title
        serviceDetailView.mapView.delegate = self
        serviceDetailView.directionControl.addTarget(self,
                                                   action: #selector(directionChanged),
                                                   for: .valueChanged)
    }
    
    private func setupBindings() {
        viewModel.$stops
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stops in
                self?.updateMapAnnotations(stops: stops)
            }
            .store(in: &cancellables)
        
        viewModel.$vehicleAnnotations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] vehicles in
                self?.updateVehicleAnnotations(vehicles)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.serviceDetailView.activityIndicator.startAnimating()
                } else {
                    self?.serviceDetailView.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$availableDirections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] directions in
                self?.updateDirectionControl(with: directions)
            }
            .store(in: &cancellables)
    }
    
    private func setupMapView() {
        serviceDetailView.mapView.delegate = self
        serviceDetailView.mapView.register(MKMarkerAnnotationView.self,
                                         forAnnotationViewWithReuseIdentifier: AnnotationIdentifier.stop)
        serviceDetailView.mapView.register(MKMarkerAnnotationView.self,
                                         forAnnotationViewWithReuseIdentifier: AnnotationIdentifier.vehicle)
    }
    
    private func updateMapAnnotations(stops: [Stop]) {
     
        let existingAnnotations = serviceDetailView.mapView.annotations.filter { $0 is StopAnnotation }
        serviceDetailView.mapView.removeAnnotations(existingAnnotations)
        
        let annotations = stops.map { stop -> StopAnnotation in
            let annotation = StopAnnotation(stop: stop)
            annotation.title = stop.name
            annotation.subtitle = "Direction: \(stop.direction ?? "N/A")"
            return annotation
        }
        
        serviceDetailView.mapView.addAnnotations(annotations)
        
        if !stops.isEmpty {
            let region = regionForStops(stops)
            serviceDetailView.mapView.setRegion(region, animated: true)
        }
    }
    
    private func regionForStops(_ stops: [Stop]) -> MKCoordinateRegion {
        let locations = stops.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        
        var minLat = locations.first?.latitude ?? 0
        var maxLat = minLat
        var minLon = locations.first?.longitude ?? 0
        var maxLon = minLon
        
        locations.forEach { coordinate in
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func updateVehicleAnnotations(_ vehicles: [ServiceDetailViewModel.VehicleAnnotationViewModel]) {
    
        let existingAnnotations = serviceDetailView.mapView.annotations
            .compactMap { $0 as? VehicleAnnotation }
            .reduce(into: [String: VehicleAnnotation]()) { dict, annotation in
                dict[annotation.vehicleId] = annotation
            }
        var newAnnotations = [VehicleAnnotation]()
        
        for vehicle in vehicles {
            if let existingAnnotation = existingAnnotations[vehicle.vehicleId] {
                
                UIView.animate(withDuration: 1.0) {
                    existingAnnotation.coordinate = vehicle.coordinate
                }
                
                existingAnnotation.title = vehicle.title
                existingAnnotation.subtitle = vehicle.subtitle
            } else {
                let annotation = VehicleAnnotation(coordinate: vehicle.coordinate, vehicleId: vehicle.vehicleId)
                annotation.title = vehicle.title
                annotation.subtitle = vehicle.subtitle
                newAnnotations.append(annotation)
            }
        }
        
        let currentVehicleIds = Set(vehicles.map { $0.vehicleId })
        let annotationsToRemove = existingAnnotations.values.filter { !currentVehicleIds.contains($0.vehicleId) }
        
        if !newAnnotations.isEmpty {
            serviceDetailView.mapView.addAnnotations(newAnnotations)
        }
        if !annotationsToRemove.isEmpty {
            serviceDetailView.mapView.removeAnnotations(Array(annotationsToRemove))
        }
    }
    
    private func updateDirectionControl(with directions: [RouteDirection]) {
        serviceDetailView.directionControl.removeAllSegments()
        
        for (index, direction) in directions.enumerated() {
            serviceDetailView.directionControl.insertSegment(
                withTitle: direction.rawValue,
                at: index,
                animated: false
            )
        }
        
        if !directions.isEmpty {
            serviceDetailView.directionControl.selectedSegmentIndex = 0
        }
    }
    
    @objc private func directionChanged(_ sender: UISegmentedControl) {
        let direction = viewModel.availableDirections[sender.selectedSegmentIndex]
        viewModel.setDirection(direction)
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error",
                                     message: error,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ServiceDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MapAnnotationView.createAnnotationView(for: annotation, on: mapView)
    }
    
    func mapView(_ mapView: MKMapView, shouldCluster annotation: MKAnnotation) -> Bool {
        return false
    }
}
