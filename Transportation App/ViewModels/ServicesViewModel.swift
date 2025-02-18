//
//  ServicesViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation
import Combine

enum TransportType {
    case all
    case bus
    case tram
}

final class ServicesViewModel {
    @Published private(set) var services: [String] = []
    @Published private(set) var filteredServices: [String] = []
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published private(set) var selectedTransportType: TransportType = .all
    
    private let service: TransportService
    private let favoritesService: FavoritesService
    private var allStops: [Stop] = []
    private var currentSearchText: String?
    private var cancellables = Set<AnyCancellable>()
    
    init(service: TransportService = TransportService(),
         favoritesService: FavoritesService = FavoritesService.shared) {
        self.service = service
        self.favoritesService = favoritesService
        setupBindings()
    }
    
    private func setupBindings() {
        favoritesService.favoritesDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if let currentServices = self?.filteredServices {
                    self?.filteredServices = currentServices
                }
            }
            .store(in: &cancellables)
    }
    
    func isFavorite(serviceNumber: String) -> Bool {
        return favoritesService.isFavorite(id: serviceNumber)
    }
    
    func toggleFavorite(serviceNumber: String) {
        favoritesService.toggleFavorite(
            id: serviceNumber,
            name: serviceNumber,
            type: .service
        )
    }
    
    func fetchServices() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let stops = try await service.fetchStops()
               await MainActor.run {
                    self.allStops = stops.stops
                    let allServices = stops.stops
                        .compactMap { $0.services }
                        .flatMap { $0 }
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    self.services = Array(Set(allServices))
                        .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
                    self.filteredServices = self.services
                    self.isLoading = false
                }
                  await MainActor.run {
                    self.filteredServices = self.filteredServices
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
        currentSearchText = searchText
        
        updateTransportType(selectedTransportType)
        
        if !searchText.isEmpty {
            filteredServices = filteredServices.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func updateTransportType(_ type: TransportType) {
        selectedTransportType = type
        
        switch type {
        case .all:
            filteredServices = services
        case .bus:
            filteredServices = services.filter { service in
                guard let serviceType = getServiceType(for: service) else { return false }
                return serviceType.lowercased() != "tram"
            }
        case .tram:
            filteredServices = services.filter { service in
                guard let serviceType = getServiceType(for: service) else { return false }
                return serviceType.lowercased() == "tram"
            }
        }
        
        if let searchText = currentSearchText, !searchText.isEmpty {
            filterServices(with: searchText)
        }
    }
    
    func getServiceType(for service: String) -> String? {
        if let stop = allStops.first(where: { stop in
            guard let services = stop.services else { return false }
            return services.contains(service)
        }) {
            return stop.serviceType
        }
        return nil
    }
    func getServiceStopDetails(for serviceNumber: String) -> (first: String, last: String)? {
        let serviceStops = allStops.filter { stop in
            guard let services = stop.services else { return false }
            return services.contains(serviceNumber)
        }
        
        if let firstStop = serviceStops.first?.name,
           let lastStop = serviceStops.last?.name {
            return (firstStop, lastStop)
        }
        
        return nil
    }
}
