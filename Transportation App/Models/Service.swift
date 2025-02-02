//
//  Service.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

struct ServicesResponse: Codable {
    let lastUpdated: Int
    let services: [Service]
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case services
    }
}

struct Service: Codable {
    let name: String
    let description: String?
    let serviceType: String
    let routes: [Route]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case serviceType = "service_type"
        case routes
        case status
    }
}

struct Route: Codable {
    let destination: String
    let points: [Point]
    let stops: [String]
}

struct Point: Codable {
    let latitude: Double
    let longitude: Double
    let stopId: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case stopId = "stop_id"
    }
} 
