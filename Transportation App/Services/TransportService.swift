//
//  TransportService.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 29.01.2025.
//

import Foundation

final class TransportService {
    private let session: URLSession
    private let baseURL = "https://tfe-opendata.com/api/v1"
    private let retryCount = 3
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        self.session = URLSession(configuration: configuration)
    }
    
    private func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw URLError(.badURL)
        }
                
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(T.self, from: data)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func fetchStops() async throws -> StopsResponse {
        guard let url = URL(string: "\(baseURL)/stops") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw NetworkError.serverError("Server Error: \(httpResponse.statusCode)")
            }
            
            do {
                let response = try JSONDecoder().decode(StopsResponse.self, from: data)
                return response
            } catch {
                throw NetworkError.decodingError(error.localizedDescription)
            }
        } catch {
            if error is NetworkError {
                throw error
            } else {
                throw NetworkError.networkConnection
            }
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
          
            
            let decoder = JSONDecoder()
            let vehicleResponse = try decoder.decode(VehicleResponse.self, from: data)
            return vehicleResponse.vehicles
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
