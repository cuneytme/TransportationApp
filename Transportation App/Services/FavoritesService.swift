import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

final class FavoritesService {
    private let defaults = UserDefaults.standard
    private let favoritesKey = "userFavorites"
    
    func getFavorites() -> [Favorite] {
        guard let data = defaults.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Favorite].self, from: data) else {
            return []
        }
        return favorites
    }
    
    func saveFavorite(_ favorite: Favorite) {
        var favorites = getFavorites()
        favorites.append(favorite)
        if let encoded = try? JSONEncoder().encode(favorites) {
            defaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(_ favorite: Favorite) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == favorite.id }
        if let encoded = try? JSONEncoder().encode(favorites) {
            defaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    func isFavorite(id: String) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.id == id }
    }
    
    func toggleFavorite(id: String, name: String, type: Favorite.FavoriteType) {
        if isFavorite(id: id) {
            if let favorite = getFavorites().first(where: { $0.id == id }) {
                removeFavorite(favorite)
            }
        } else {
            let favorite = Favorite(id: id, type: type, name: name, date: Date())
            saveFavorite(favorite)
        }
        
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
} 
