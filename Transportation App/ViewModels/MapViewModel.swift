//
//  MapViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 28.01.2025.
//

import Foundation
import MapKit

final class MapViewModel {
    private let service = TransportService()
    
    @Published var stops: [Stop] = []
    @Published var vehicles: [Vehicle] = []
    @Published var error: String?
    
    func fetchStopsAndVehicles() async {
        do {
            async let stopsResult = service.fetchStops()
            async let vehiclesResult = service.fetchVehicles()
            
            let (stopsResponse, fetchedVehicles) = try await (stopsResult, vehiclesResult)
            
            await MainActor.run {
                self.stops = stopsResponse.stops
                self.vehicles = fetchedVehicles
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
        }
    }
    
    func startLiveUpdates() {
        Task {
            while true {
                await fetchStopsAndVehicles()
                try? await Task.sleep(nanoseconds: 30_000_000_000)
            }
        }
    }
} 
