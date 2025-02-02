//
//  Vehicle.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

struct VehicleResponse: Codable {
    let lastUpdated: Int
    let vehicles: [Vehicle]
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case vehicles
    }
}

struct Vehicle: Codable {
    let vehicleId: String
    let latitude: Double
    let longitude: Double
    let heading: Double?
    let speed: Double?
    let bearing: Double?
    let serviceName: String?
    let destination: String?
    let journeyId: String?
    
    enum CodingKeys: String, CodingKey {
        case vehicleId = "vehicle_id"
        case latitude
        case longitude
        case heading
        case speed
        case bearing
        case serviceName = "service_name"
        case destination
        case journeyId = "journey_id"
    }
} 
