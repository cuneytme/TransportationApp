//
//  TimetableViewModel.swift
//  Transportation App
//
//  Created by Cüneyt Elbastı on 07.02.2025.
//



import UIKit

final class TimetableViewModel {
    private let service: TransportService
    private let serviceNumber: String
    private let stopId: Int
    
    @Published private(set) var departures: [TimetableData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    init(service: TransportService = TransportService(), serviceNumber: String, stopId: Int) {
        self.service = service
        self.serviceNumber = serviceNumber
        self.stopId = stopId
    }
    
    func fetchTimetables() async {
        await MainActor.run { self.isLoading = true }
        
        do {
            let timetables = try await service.fetchTimetable(for: stopId)
            await MainActor.run {
                self.departures = timetables
                    .filter { $0.serviceName == self.serviceNumber }
                    .sorted { $0.time < $1.time }
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
