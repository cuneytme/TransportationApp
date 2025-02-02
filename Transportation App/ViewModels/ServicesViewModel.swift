//
//  ServicesViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation
import Combine

final class ServicesViewModel {
    @Published private(set) var services: [String] = []
    @Published private(set) var filteredServices: [String] = []
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let service: TransportService
    private var allStops: [Stop] = []
    
    init(service: TransportService = TransportService()) {
        self.service = service
    }
    
    func fetchServices() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let stopsResponse = try await service.fetchStops()
                await MainActor.run {
                    self.allStops = stopsResponse.stops
                    
                    let allServices = stopsResponse.stops
                        .compactMap { $0.services }
                        .flatMap { $0 }
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    
                    self.services = Array(Set(allServices))
                        .sorted()
                        .filter { service in
                            let numericPart = service.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                .joined()
                            return !numericPart.isEmpty
                        }
                        .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
                    
                    self.filteredServices = self.services
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func selectService(_ serviceNumber: String) {
        stops = allStops.filter { stop in
            guard let services = stop.services else { return false }
            return services.contains(serviceNumber)
        }
    }
    
    func filterServices(with searchText: String) {
        if searchText.isEmpty {
            filteredServices = services
        } else {
            filteredServices = services.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
} 
