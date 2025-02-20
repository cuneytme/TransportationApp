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
    
    private struct ServiceSearchData {
        let number: String
        let firstStop: String
        let lastStop: String
        let type: String?
        
        var searchableText: String {
            return "\(number) \(firstStop) \(lastStop)".lowercased()
        }
    }
    
    private var serviceSearchData: [ServiceSearchData] = []
    
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
                    
                    self.prepareSearchData()
                    
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
    
    private func prepareSearchData() {
        serviceSearchData = services.compactMap { service in
            guard let stopDetails = getServiceStopDetails(for: service) else { return nil }
            return ServiceSearchData(
                number: service,
                firstStop: stopDetails.first,
                lastStop: stopDetails.last,
                type: getServiceType(for: service)
            )
        }
    }
    
    func filterServices(with searchText: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.currentSearchText = searchText
            
            var filteredSearchData = self.serviceSearchData
            
            switch self.selectedTransportType {
            case .all:
                break
            case .bus:
                filteredSearchData = filteredSearchData.filter { data in
                    data.type?.lowercased() != "tram"
                }
            case .tram:
                filteredSearchData = filteredSearchData.filter { data in
                    data.type?.lowercased() == "tram"
                }
            }
            if !searchText.isEmpty {
                let searchTerms = searchText.lowercased().split(separator: " ")
                filteredSearchData = filteredSearchData.filter { data in
                    searchTerms.allSatisfy { term in
                        data.searchableText.contains(term.lowercased())
                    }
                }
            }
            
            self.filteredServices = filteredSearchData.map { $0.number }
        }
    }
    
    func updateTransportType(_ type: TransportType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.selectedTransportType = type
            
            if let searchText = self.currentSearchText {
                self.filterServices(with: searchText)
            } else {
                self.filterServices(with: "")
            }
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
