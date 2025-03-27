//
//  Stop.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation

struct Stop: Codable {
    let stopId: Int
    let atcoCode: String
    let name: String
    let identifier: String?
    let locality: String?
    let orientation: Int?
    let direction: String?
    let latitude: Double
    let longitude: Double
    let serviceType: String?
    let destinations: [String]?
    let services: [String]?
    let sequence: Int?
    
    enum CodingKeys: String, CodingKey {
        case stopId = "stop_id"
        case atcoCode = "atco_code"
        case name
        case identifier
        case locality
        case orientation
        case direction
        case latitude
        case longitude
        case serviceType = "service_type"
        case destinations
        case services
        case sequence
    }
}

struct StopsResponse: Codable {
    let lastUpdated: Int
    let stops: [Stop]
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case stops
    }
}

struct ServiceJourneyResponse: Codable {
    let service: ServiceJourney
}

struct ServiceJourney: Codable {
    let serviceId: String
    let stops: [ServiceStop]
    
    enum CodingKeys: String, CodingKey {
        case serviceId = "service_id"
        case stops
    }
}

struct ServiceStop: Codable {
    let stopId: String
    let name: String
    let direction: String?
    
    enum CodingKeys: String, CodingKey {
        case stopId = "stop_id"
        case name = "stop_name"
        case direction
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkConnection
    case serverError(String)
    case decodingError(String)
}
