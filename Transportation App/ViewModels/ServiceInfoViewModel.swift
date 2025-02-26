//
//  ServiceInfoViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//

import Foundation
import Combine

final class ServiceInfoViewModel {
    private let serviceNumber: String
    private let service: TransportService
    
    @Published private(set) var stops: [Stop] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    var dismissTrigger: (() -> Void)?
    
    init(serviceNumber: String, service: TransportService = TransportService()) {
        self.serviceNumber = serviceNumber
        self.service = service
        fetchServiceStops()
    }

    private func fetchServiceStops() {
        isLoading = true
        
        Task {
            do {
                let stopsResponse = try await service.fetchStops()
                await MainActor.run {
                    self.stops = stopsResponse.stops.filter { stop in
                        stop.services?.contains(self.serviceNumber) ?? false
                    }
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
    
    private func setLoadingState(_ loading: Bool) async {
        await MainActor.run {
            self.isLoading = loading
            if loading {
                self.error = nil
            }
        }
    }
    

    private func handleError(_ error: Error) async {
        await MainActor.run {
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func getServiceNumber() -> String {
        return serviceNumber
    }
    
    func getFirstStopId() -> Int? {
        return stops.first?.stopId
    }
    
    func handleBackgroundTap() {
        dismissTrigger?()
    }
} 
