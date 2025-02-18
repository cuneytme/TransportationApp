import Foundation
import Combine

final class FavoritesViewModel {
    @Published private(set) var favorites: [Favorite] = []
    @Published private(set) var navigationAction: NavigationAction?
    
    private let favoritesService: FavoritesService
    private var cancellables = Set<AnyCancellable>()
    
    enum NavigationAction {
        case showServiceInfo(serviceNumber: String)
        case showStopDetail(stop: Stop)
    }
    
    init(favoritesService: FavoritesService = FavoritesService.shared) {
        self.favoritesService = favoritesService
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
        DispatchQueue.main.async {
            self.favorites = self.favoritesService.getFavorites()
                .sorted { $0.date > $1.date }
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
} 
