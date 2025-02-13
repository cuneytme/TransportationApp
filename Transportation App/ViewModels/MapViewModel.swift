//
//  MapViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import MapKit

final class MapViewModel: NSObject {
    private let locationManager: CLLocationManager
    private let service: TransportServiceProtocol
    private let maximumDistance: Double = 1000
    
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var error: String?
    @Published private(set) var userLocation: CLLocationCoordinate2D
    @Published private(set) var isUpdatingLocation: Bool = false
    @Published private(set) var shouldUpdateUserAnnotation: Bool = false
    
    init(service: TransportServiceProtocol = TransportService(),
         locationManager: CLLocationManager = CLLocationManager()) {
        self.service = service
        self.locationManager = locationManager
        self.userLocation = CLLocationCoordinate2D(latitude: 55.9533, longitude: -3.1883)
        super.init()
        self.shouldUpdateUserAnnotation = true
    }
    
    func fetchStopsAndVehicles() async {
        do {
            let stops = try await service.fetchStops()
            
            await MainActor.run {
                self.stops = self.filterNearbyStops(stops.stops)
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
        }
    }
    
    private func filterNearbyStops(_ stops: [Stop]) -> [Stop] {
        let userLocationObject = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        let nearbyStops = stops.filter { stop in
            let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
            let distance = userLocationObject.distance(from: stopLocation)
            return distance <= maximumDistance
        }
        
        var groupedStops: [String: [Stop]] = [:]
        for stop in nearbyStops {
            groupedStops[stop.name, default: []].append(stop)
        }
        var finalStops: [Stop] = []
        
        for sameNameStops in groupedStops.values {
            if sameNameStops.count == 1 {
                finalStops.append(sameNameStops[0])
                continue
            }
            
            var processedIndices = Set<Int>()
            
            for (index, stop) in sameNameStops.enumerated() {
                if processedIndices.contains(index) { continue }
                
                let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
                
                for (otherIndex, otherStop) in sameNameStops.enumerated() {
                    if processedIndices.contains(otherIndex) { continue }
                    
                    let otherLocation = CLLocation(latitude: otherStop.latitude, longitude: otherStop.longitude)
                    if stopLocation.distance(from: otherLocation) < 50 {
                        processedIndices.insert(otherIndex)
                    }
                }
                
                finalStops.append(stop)
            }
        }
        
        return finalStops
    }
    
    func startLiveUpdates() {
        Task {
            while true {
                await fetchStopsAndVehicles()
                try? await Task.sleep(nanoseconds: 30_000_000_000)
            }
        }
    }
    
    func moveToUserLocation() {
        isUpdatingLocation = true
        shouldUpdateUserAnnotation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isUpdatingLocation = false
        }
    }
    
    func resetUserAnnotationFlag() {
        shouldUpdateUserAnnotation = false
    }
} 
