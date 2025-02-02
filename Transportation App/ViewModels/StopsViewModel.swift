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
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let service: TransportService
    
    init(service: TransportService = TransportService()) {
        self.service = service
    }
    
    func fetchStops() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await service.fetchStops()
                await MainActor.run {
                    self.stops = response.stops
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
} 
