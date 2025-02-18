//
//  StopsViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation
import Combine

final class StopsViewModel {
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var filteredStops: [Stop] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let service: TransportService
    private let favoritesService: FavoritesService
    
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
                if let currentStops = self?.filteredStops {
                    self?.filteredStops = currentStops
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchStops() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await service.fetchStops()
                await MainActor.run {
                    self.stops = response.stops
                    self.filteredStops = response.stops
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
    
    func filterStops(with searchText: String) {
        if searchText.isEmpty {
            filteredStops = stops
        } else {
            filteredStops = stops.filter { stop in
                let searchableText = [
                    stop.name,
                    stop.locality,
                    stop.services?.joined(separator: " ") ?? ""
                ].joined(separator: " ").lowercased()
                
                return searchableText.contains(searchText.lowercased())
            }
        }
    }
    
    func isFavorite(stopId: Int) -> Bool {
        return favoritesService.isFavorite(id: String(stopId))
    }
    
    func toggleFavorite(stop: Stop) {
        favoritesService.toggleFavorite(
            id: String(stop.stopId),
            name: stop.name,
            type: .stop
        )
    }
} 
