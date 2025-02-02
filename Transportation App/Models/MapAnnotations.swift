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
    let vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
    }
} 
