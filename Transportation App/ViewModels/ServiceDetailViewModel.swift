//
//  ServiceDetailViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation
import MapKit
import Combine

final class ServiceDetailViewModel {
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var vehicles: [Vehicle] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published private(set) var selectedDirection: RouteDirection = .outbound
    @Published private(set) var availableDirections: [RouteDirection] = [.outbound, .inbound]
    
    private let service: TransportService
    let serviceNumber: String
    private var allStops: [Stop] = []
    
    var title: String {
        return "Service \(serviceNumber)"
    }
    
    init(service: TransportService = TransportService(), serviceNumber: String) {
        self.service = service
        self.serviceNumber = serviceNumber
    }
    
    func fetchServiceDetails() {
        isLoading = true
        error = nil
        
        Task {
            do {
              
                let stopsResponse = try await service.fetchStops()
                
                await MainActor.run {
                    
                    self.allStops = stopsResponse.stops.filter { stop in
                        stop.services?.contains(self.serviceNumber) ?? false
                    }
                 
                    self.updateStopsForDirection()
                }
                
                Task {
                    let vehicles = try await service.fetchVehicles()
                    await MainActor.run {
                        self.vehicles = vehicles.filter { vehicle in
                            vehicle.serviceName == self.serviceNumber
                        }
                    }
                }
                
                self.isLoading = false
                
            } catch {
                await MainActor.run {
                    print("DEBUG: Error occurred: \(error)")
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func setDirection(_ direction: RouteDirection) {
      
        selectedDirection = direction
        updateStopsForDirection()
    }
    
    private func updateStopsForDirection() {
    
        let serviceFilteredStops = allStops.filter { stop in
            guard let services = stop.services else {
                return false
            }
            
            let hasMatchingService = services.contains { service in
                let normalizedService = service.trimmingCharacters(in: .whitespacesAndNewlines)
                let matches = normalizedService == serviceNumber
              
                return matches
            }
            
            return hasMatchingService
        }
        
        let stopGroups = Dictionary(grouping: serviceFilteredStops) { stop -> String in
            return getBaseStopName(stop.name)
        }
        
        var outboundStops: [Stop] = []
        var inboundStops: [Stop] = []
        
        for (baseName, stops) in stopGroups {
          
            
            if stops.count > 1 {
               
                assignDirectionsForSameNameStops(stops, outboundStops: &outboundStops, inboundStops: &inboundStops)
            } else if let stop = stops.first {
            
                assignDirectionForSingleStop(stop, outboundStops: &outboundStops, inboundStops: &inboundStops)
            }
        }
        
        stops = selectedDirection == .outbound ? outboundStops : inboundStops
     
    }
    
    private func getBaseStopName(_ fullName: String) -> String {
      
        return fullName.replacingOccurrences(of: "\\s*\\([^)]*\\)", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
    
    private func getStopCode(_ stopName: String) -> String? {
      
        if let range = stopName.range(of: "\\(Stop ([^)]+)\\)", options: .regularExpression),
           let codeRange = stopName[range].range(of: "Stop (.+)\\)", options: .regularExpression) {
            let code = stopName[codeRange].dropFirst(5).dropLast()
            return String(code)
        }
        return nil
    }
    
    private func assignDirectionsForSameNameStops(_ stops: [Stop], outboundStops: inout [Stop], inboundStops: inout [Stop]) {
        guard stops.count >= 2 else { return }
        
        if let firstStopCode = getStopCode(stops[0].name),
           let secondStopCode = getStopCode(stops[1].name) {
            let firstIsOutbound = isOutboundStopCode(firstStopCode)
            if firstIsOutbound {
                outboundStops.append(stops[0])
                inboundStops.append(stops[1])
            } else {
                outboundStops.append(stops[1])
                inboundStops.append(stops[0])
            }
            return
        }
        
        let sortedStops = stops.sorted { $0.latitude > $1.latitude }
        
        if stops.count == 2 {
            let stop1 = sortedStops[0]
            let stop2 = sortedStops[1]
            
         
            if let dir1 = stop1.direction, let dir2 = stop2.direction {
                if isOutboundDirection(dir1) && !isOutboundDirection(dir2) {
                    outboundStops.append(stop1)
                    inboundStops.append(stop2)
                } else if !isOutboundDirection(dir1) && isOutboundDirection(dir2) {
                    outboundStops.append(stop2)
                    inboundStops.append(stop1)
                } else {
                   
                    assignBasedOnLocation(stop1, stop2, outboundStops: &outboundStops, inboundStops: &inboundStops)
                }
            } else {
              
                assignBasedOnLocation(stop1, stop2, outboundStops: &outboundStops, inboundStops: &inboundStops)
            }
        }
    }
    
    private func assignBasedOnLocation(_ stop1: Stop, _ stop2: Stop, outboundStops: inout [Stop], inboundStops: inout [Stop]) {
        if stop1.longitude > stop2.longitude {
            outboundStops.append(stop1)
            inboundStops.append(stop2)
        } else {
            outboundStops.append(stop2)
            inboundStops.append(stop1)
        }
    }
    
    private func isOutboundDirection(_ direction: String) -> Bool {
        let outboundDirections = ["S", "SE", "E"]
        return outboundDirections.contains(direction)
    }
    
    private func assignDirectionForSingleStop(_ stop: Stop, outboundStops: inout [Stop], inboundStops: inout [Stop]) {
        if let stopCode = getStopCode(stop.name) {
            if isOutboundStopCode(stopCode) {
                outboundStops.append(stop)
            } else {
                inboundStops.append(stop)
            }
            return
        }
        
        if let direction = stop.direction {
            if isOutboundDirection(direction) {
                outboundStops.append(stop)
            } else {
                inboundStops.append(stop)
            }
        } else {
            outboundStops.append(stop)
        }
    }
    
    private func normalizeServiceNumber(_ service: String) -> String {
        return service.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func startLiveUpdates() {
        Task {
            while true {
                do {
                    let vehicles = try await service.fetchVehicles()
                    await MainActor.run {
                        self.vehicles = vehicles.filter { vehicle in
                            vehicle.serviceName == self.serviceNumber
                        }
                    }
                    try await Task.sleep(nanoseconds: 30_000_000_000)
                } catch {
                   
                }
            }
        }
    }
    
    private func isOutboundStopCode(_ code: String) -> Bool {
       
        let outboundCodes = ["IK", "IA", "IC", "IE", "IG", "II"]
        let inboundCodes = ["IF", "IB", "ID", "IH", "IJ"]
        
        if outboundCodes.contains(code) {
            return true
        }
        if inboundCodes.contains(code) {
            return false
        }
        
        if let lastChar = code.last {
            return Int(lastChar.asciiValue ?? 0) % 2 == 1
        }
        
        return false
    }
    
    struct VehicleAnnotationViewModel {
        let coordinate: CLLocationCoordinate2D
        let title: String
        let subtitle: String
        
        init(vehicle: Vehicle) {
            self.coordinate = CLLocationCoordinate2D(latitude: vehicle.latitude, longitude: vehicle.longitude)
            self.title = "Bus \(vehicle.serviceName ?? "Unknown")"
            self.subtitle = vehicle.destination ?? "Unknown Destination"
        }
    }
    
    @Published private(set) var vehicleAnnotations: [VehicleAnnotationViewModel] = []
    
    private func updateVehicleAnnotations(_ vehicles: [Vehicle]) {
        self.vehicleAnnotations = vehicles.map { VehicleAnnotationViewModel(vehicle: $0) }
    }
}
