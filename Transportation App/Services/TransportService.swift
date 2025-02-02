//
//  TransportService.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation

final class TransportService {
    private let baseURL = "https://tfe-opendata.com"
    
    func fetchStops() async throws -> StopsResponse {
        guard let url = URL(string: "\(baseURL)/api/v1/stops") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                print("HTTP Error: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
            if let jsonString = String(data: data, encoding: .utf8) {
               // print("JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(StopsResponse.self, from: data)
        } catch {
            print("Network/Decode Error: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key), context: \(context)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch: \(type), context: \(context)")
                case .valueNotFound(let type, let context):
                    print("Value not found: \(type), context: \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            throw error
        }
    }
    
    func fetchVehicles() async throws -> [Vehicle] {
        guard let url = URL(string: "\(baseURL)/api/v1/vehicle_locations") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                print("HTTP Error: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
               // print("Vehicles JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehicleResponse.self, from: data)
            return vehicleResponse.vehicles
        } catch {
            print("Vehicle Decode Error: \(error)")
            throw error
        }
    }
    
    func fetchServices() async throws -> ServicesResponse {
        guard let url = URL(string: "\(baseURL)/api/v1/services") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("3e48d4c3-b853-4d9e-85c2-4a0f49f35df7", forHTTPHeaderField: "X-API-KEY")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                print("HTTP Error: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
              //  print("Services JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ServicesResponse.self, from: data)
                return response
            } catch {
                print("Services Decode Error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), context: \(context)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), context: \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), context: \(context)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
                throw error
            }
        } catch {
            print("Network Error: \(error)")
            throw error
        }
    }
} 
