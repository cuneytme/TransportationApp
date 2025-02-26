//
//  TransportServiceProtocol.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 20.02.2025.
//

import Foundation

protocol TransportServiceProtocol {
    func fetchStops() async throws -> StopsResponse
    func fetchVehicles() async throws -> [Vehicle]
    func fetchLiveBusTimes(for stopId: Int) async throws -> [BusRoute]
    func fetchServiceJourney(for serviceNumber: String) async throws -> ServiceJourney
    func getStopId(for stopName: String) async throws -> Int
    func fetchTimetable(for stopId: Int) async throws -> [TimetableData]
}

extension TransportService: TransportServiceProtocol { } 
