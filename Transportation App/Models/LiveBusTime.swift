//
//  LiveBusTime.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

struct BusRoute: Codable {
    let routeName: String
    let departures: [Departure]
}

struct Departure: Codable {
    let routeName: String
    let destination: String
    let departureTime: String
    let displayTime: String
    let isLive: Bool
    let vehicleId: String
    
    enum CodingKeys: String, CodingKey {
        case routeName = "routeName"
        case destination
        case departureTime = "departureTime"
        case displayTime
        case isLive
        case vehicleId
    }
} 
