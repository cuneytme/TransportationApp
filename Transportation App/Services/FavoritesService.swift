//
//  FavoritesService.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 20.02.2025.
//


import Foundation
import Combine

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}

final class FavoritesService {
    static let shared = FavoritesService() 
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "userFavorites"
    
    let favoritesDidChangePublisher = PassthroughSubject<Void, Never>()
    
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
        saveFavorites(favorites)
    }
    
    func removeFavorite(_ favorite: Favorite) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == favorite.id }
        saveFavorites(favorites)
    }
    
    private func saveFavorites(_ favorites: [Favorite]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            defaults.set(encoded, forKey: favoritesKey)
            defaults.synchronize()
            DispatchQueue.main.async {
                self.favoritesDidChangePublisher.send()
            }
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
    }
} 
