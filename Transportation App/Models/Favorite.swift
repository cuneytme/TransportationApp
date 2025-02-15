import Foundation


struct Favorite: Codable {
    let id: String
    let type: FavoriteType
    let name: String
    let date: Date
    
    enum FavoriteType: String, Codable {
        case service
        case stop
    }
} 
