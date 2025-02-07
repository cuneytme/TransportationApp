//
//  TransportService.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation

final class TransportService {
    private let baseURL = "https://tfe-opendata.com/api/v1"
    
    func fetchStops() async throws -> StopsResponse {
        guard let url = URL(string: "\(baseURL)/stops") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 0 {
                    throw NetworkError.networkConnection
                }
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            return try JSONDecoder().decode(StopsResponse.self, from: data)
        } catch let error as NetworkError {
            throw error
        } catch {
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                throw NetworkError.networkConnection
            }
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
    
    func fetchVehicles() async throws -> [Vehicle] {
        guard let url = URL(string: "\(baseURL)/vehicle_locations") else {
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
              
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
               // print("Vehicles JSON Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehicleResponse.self, from: data)
            return vehicleResponse.vehicles
        } catch {
         
            throw error
        }
    }
    
    func fetchServices() async throws -> ServicesResponse {
        guard let url = URL(string: "\(baseURL)/services") else {
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
              
             
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func fetchLiveBusTimes(for stopId: Int) async throws -> [BusRoute] {
        guard let url = URL(string: "\(baseURL)/live_bus_times/\(stopId)") else {
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
             
                throw URLError(.badServerResponse)
            }
           
            
            let decoder = JSONDecoder()
            return try decoder.decode([BusRoute].self, from: data)
        } catch {
        
           
            throw error
        }
    }
    
  
    func fetchServiceJourney(for serviceNumber: String) async throws -> ServiceJourney {
        guard let url = URL(string: "\(baseURL)/services/\(serviceNumber)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        
        let journeyResponse = try JSONDecoder().decode(ServiceJourneyResponse.self, from: data)
        return journeyResponse.service
    }
    
    func getStopId(for stopName: String) async throws -> Int {
   
        guard let encodedName = stopName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/stops?name=\(encodedName)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let stops = try JSONDecoder().decode([ServiceStop].self, from: data)
        
        guard let stop = stops.first else {
            throw NSError(domain: "TransportService", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "\(stopName)"
            ])
        }
        
        return Int(stop.stopId) ?? 36232897
    }
    
    func fetchTimetable(for stopId: Int) async throws -> [TimetableData] {
        guard let url = URL(string: "\(baseURL)/timetables/\(stopId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError("HTTP \(httpResponse.statusCode)")
            }
            
            
            let decoder = JSONDecoder()
            let timetableResponse = try decoder.decode(TimetableResponse.self, from: data)
            return timetableResponse.departures
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError("\(decodingError.localizedDescription)")
        } catch {
            throw NetworkError.networkConnection
        }
    }
}

struct ServiceJourneyResponse: Codable {
    let service: ServiceJourney
}

struct ServiceJourney: Codable {
    let serviceId: String
    let stops: [ServiceStop]
    
    enum CodingKeys: String, CodingKey {
        case serviceId = "service_id"
        case stops
    }
}

struct ServiceStop: Codable {
    let stopId: String
    let name: String
    let direction: String?
    
    enum CodingKeys: String, CodingKey {
        case stopId = "stop_id"
        case name = "stop_name"
        case direction
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkConnection
    case serverError(String)
    case decodingError(String)
    
}
