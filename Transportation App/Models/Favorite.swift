//
//  Favorite.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 23.02.2025.
//

import Foundation


struct Favorite: Codable, Hashable {
    let id: String
    let type: FavoriteType
    let name: String
    let date: Date
    
    enum FavoriteType: String, Codable, Hashable {
        case service
        case stop
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }
    
    static func == (lhs: Favorite, rhs: Favorite) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
} 
