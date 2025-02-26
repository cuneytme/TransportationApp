//
//  MapAnnotations.swift.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//


import MapKit

class StopAnnotation: MKPointAnnotation {
    let stop: Stop
    
    init(stop: Stop) {
        self.stop = stop
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
    }
}

class VehicleAnnotation: MKPointAnnotation {
    let vehicleId: String
    
    init(coordinate: CLLocationCoordinate2D, vehicleId: String) {
        self.vehicleId = vehicleId
        super.init()
        self.coordinate = coordinate
    }
}

class UserLocationAnnotation: MKPointAnnotation {
    override init() {
        super.init()
    }
} 
