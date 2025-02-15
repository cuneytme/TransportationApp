//
//  StopDetailViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//


import UIKit

final class StopDetailViewModel {
    private let service: TransportService
    private let stop: Stop
    
    @Published private(set) var liveTimes: [BusRoute] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    var onServiceSelected: ((String) -> Void)?
    
    init(service: TransportService = TransportService(), stop: Stop) {
        self.service = service
        self.stop = stop
    }
    
    var title: String {
        return stop.name
    }
    
    func fetchLiveTimes() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let times = try await service.fetchLiveBusTimes(for: stop.stopId)
                await MainActor.run {
                    self.liveTimes = times
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
    
    func startLiveUpdates() {
        Task {
            while true {
                await fetchLiveTimes()
                try? await Task.sleep(nanoseconds: 30_000_000_000)
            }
        }
    }
    
    func didSelectService(_ serviceName: String) {
        onServiceSelected?(serviceName)
    }
} 
