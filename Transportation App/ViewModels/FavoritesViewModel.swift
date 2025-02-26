//
//  FavoritesViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import Foundation
import Combine

final class FavoritesViewModel {
    @Published private(set) var favorites: [Favorite] = []
    @Published private(set) var filteredFavorites: [Favorite] = []
    @Published private(set) var currentSearchText: String?
    @Published private(set) var navigationAction: NavigationAction?
    
    private let favoritesService: FavoritesService
    private let transportService: TransportService
    private var cancellables = Set<AnyCancellable>()
    private var stopDetailsCache: [String: (first: String, last: String)] = [:]
    
    enum NavigationAction {
        case showServiceInfo(serviceNumber: String)
        case showStopDetail(stop: Stop)
    }
    
    init(favoritesService: FavoritesService = FavoritesService.shared,
         transportService: TransportService = TransportService()) {
        self.favoritesService = favoritesService
        self.transportService = transportService
        setupBindings()
        loadFavorites()
    }
    
    private func setupBindings() {
        favoritesService.favoritesDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadFavorites()
            }
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        let sortedFavorites = favoritesService.getFavorites()
            .sorted { $0.date > $1.date }
        
        favorites = Array(Set(sortedFavorites))
        Task {
            for favorite in favorites where favorite.type == .service {
                if stopDetailsCache[favorite.id] == nil {
                    if let details = try? await getServiceStopDetails(for: favorite.id) {
                        stopDetailsCache[favorite.id] = details
                    }
                }
            }
            await MainActor.run {
                filterFavorites(with: currentSearchText ?? "")
            }
        }
    }
    
    func filterFavorites(with searchText: String) {
        currentSearchText = searchText
        
        if searchText.isEmpty {
            filteredFavorites = favorites
            return
        }
        
        let searchTerms = searchText.lowercased().split(separator: " ")
        
        filteredFavorites = favorites.filter { favorite in
            var searchableText = [
                favorite.name.lowercased(),
                favorite.type.rawValue.lowercased()
            ]
            
            if favorite.type == .service, let stopDetails = stopDetailsCache[favorite.id] {
                searchableText.append(stopDetails.first.lowercased())
                searchableText.append(stopDetails.last.lowercased())
            }
            
            return searchTerms.allSatisfy { searchTerm in
                searchableText.contains { text in
                    text.contains(searchTerm)
                }
            }
        }
    }
    
    func removeFavorite(_ favorite: Favorite) {
        favoritesService.removeFavorite(favorite)
        loadFavorites()
    }
    
    func toggleFavorite(id: String, name: String, type: Favorite.FavoriteType) {
        favoritesService.toggleFavorite(id: id, name: name, type: type)
    }
    
    func navigateToDetail(for favorite: Favorite) {
        switch favorite.type {
        case .service:
            navigationAction = .showServiceInfo(serviceNumber: favorite.id)
        case .stop:
            if let stop = createStop(from: favorite) {
                navigationAction = .showStopDetail(stop: stop)
            }
        }
    }
    
    private func createStop(from favorite: Favorite) -> Stop? {
        guard let stopId = Int(favorite.id) else { return nil }
        
        return Stop(
            stopId: stopId,
            atcoCode: favorite.id,
            name: favorite.name,
            identifier: favorite.id,
            locality: "",
            orientation: nil,
            direction: nil,
            latitude: 0,
            longitude: 0,
            serviceType: "",
            destinations: [],
            services: nil,
            sequence: 0
        )
    }
    
    func getServiceType(for service: String) async throws -> String? {
        let stopsResponse = try await transportService.fetchStops()
        return stopsResponse.stops.first { stop in
            guard let services = stop.services else { return false }
            return services.contains(service)
        }?.serviceType
    }
    
    func getServiceStopDetails(for serviceNumber: String) async throws -> (first: String, last: String)? {
        let stopsResponse = try await transportService.fetchStops()
        let serviceStops = stopsResponse.stops.filter { stop in
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
