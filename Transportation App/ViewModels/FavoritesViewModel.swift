import Foundation
import Combine

final class FavoritesViewModel {
    @Published private(set) var favorites: [Favorite] = []
    @Published private(set) var navigationAction: NavigationAction?
    
    private let favoritesService: FavoritesService
    
    enum NavigationAction {
        case showServiceInfo(serviceNumber: String)
        case showStopDetail(stop: Stop)
    }
    
    init(favoritesService: FavoritesService = FavoritesService()) {
        self.favoritesService = favoritesService
    }
    
    func loadFavorites() {
        favorites = favoritesService.getFavorites()
    }
    
    func removeFavorite(_ favorite: Favorite) {
        favoritesService.removeFavorite(favorite)
        loadFavorites()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func toggleFavorite(id: String, name: String, type: Favorite.FavoriteType) {
        if favoritesService.isFavorite(id: id) {
            if let favorite = favorites.first(where: { $0.id == id }) {
                removeFavorite(favorite)
            }
        } else {
            let favorite = Favorite(id: id, type: type, name: name, date: Date())
            favoritesService.saveFavorite(favorite)
            loadFavorites()
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
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
