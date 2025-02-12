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
    private let mapView = MapView()
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
        mapView.mapView.delegate = self
    }
    
    private func setupUI() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        let edinburghCenter = CLLocationCoordinate2D(latitude: 55.9533, longitude: -3.1883)
        let region = MKCoordinateRegion(center: edinburghCenter,
                                      latitudinalMeters: 5000,
                                      longitudinalMeters: 5000)
        mapView.mapView.setRegion(region, animated: true)
        
        mapView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.$stops
            .sink { [weak self] stops in
                self?.updateStopAnnotations(stops)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { error in error }
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$userLocation
            .sink { [weak self] location in
                let region = MKCoordinateRegion(center: location,
                                              latitudinalMeters: 1000,
                                              longitudinalMeters: 1000)
                self?.mapView.mapView.setRegion(region, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$isUpdatingLocation
            .sink { [weak self] isUpdating in
                self?.mapView.locationButton.isEnabled = !isUpdating
                self?.mapView.locationButton.tintColor = isUpdating ? .gray : .systemBlue
            }
            .store(in: &cancellables)
        
        viewModel.$shouldUpdateUserAnnotation
            .filter { $0 }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateUserLocation(self.viewModel.userLocation)
                self.viewModel.resetUserAnnotationFlag()
            }
            .store(in: &cancellables)
    }
    
    private func updateStopAnnotations(_ stops: [Stop]) {
        let existingStopAnnotations = mapView.mapView.annotations.filter { $0 is StopAnnotation }
        mapView.mapView.removeAnnotations(existingStopAnnotations)
        
        let annotations = stops.map { stop in
            let annotation = StopAnnotation(stop: stop)
            annotation.coordinate = CLLocationCoordinate2D(latitude: stop.latitude,
                                                         longitude: stop.longitude)
            annotation.title = stop.name
            return annotation
        }
        
        mapView.mapView.addAnnotations(annotations)
        if existingStopAnnotations.isEmpty {
            mapView.mapView.showAnnotations(mapView.mapView.annotations, animated: true)
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error",
                                    message: error,
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func locationButtonTapped() {
        viewModel.moveToUserLocation()
        let region = MKCoordinateRegion(center: viewModel.userLocation,
                                      latitudinalMeters: 250,
                                      longitudinalMeters: 250)
        mapView.mapView.setRegion(region, animated: true)
    }
    
    private func updateUserLocation(_ location: CLLocationCoordinate2D) {
        let existingUserAnnotations = mapView.mapView.annotations.filter { $0 is UserLocationAnnotation }
        mapView.mapView.removeAnnotations(existingUserAnnotations)
        
        let annotation = UserLocationAnnotation()
        annotation.coordinate = location
        mapView.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is UserLocationAnnotation:
            let identifier = "UserLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            if let markerView = annotationView as? MKMarkerAnnotationView {
                markerView.markerTintColor = .systemBlue
                markerView.glyphImage = UIImage(systemName: "person.fill")
                markerView.displayPriority = .required
            }
            
            annotationView?.canShowCallout = false
            return annotationView
            
        case let stopAnnotation as StopAnnotation:
            let identifier = "StopAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: stopAnnotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = stopAnnotation
            }
            
            if let markerView = annotationView as? MKMarkerAnnotationView {
                markerView.markerTintColor = .systemRed
                markerView.glyphImage = UIImage(systemName: "bus.fill")
                markerView.displayPriority = .required
                markerView.canShowCallout = true
            }
            
            return annotationView
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, shouldCluster annotation: MKAnnotation) -> Bool {
        return false
    }
}

protocol MapViewControllerDelegate: AnyObject {
    func didSelectLocation(_ coordinate: CLLocationCoordinate2D)
}

